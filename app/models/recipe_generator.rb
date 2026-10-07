class RecipeGenerator < ApplicationRecord
  class GenerationError < StandardError; end

  RECIPE_COUNT = 3

  STAPLES = ["salt", "pepper", "black pepper", "water", "oil", "olive oil",
             "vegetable oil", "cooking oil", "ice", "milk"].freeze

  SYSTEM_PROMPT = <<~PROMPT.freeze
    You are a practical home-cooking assistant.
    Suggest recipes that rely mainly on the ingredients the user says they have.
    You may assume basic staples: salt, pepper, water, milk and cooking oil.
    Keep any extra ingredients to a minimum.
    Give exact numeric amounts for every ingredient and short, clear steps.
    Nutrition values are rough estimates per serving.
  PROMPT

  def initialize(chat)
    @chat = chat
    @chat.assume_model_exists = true
  end

  def call(preferences: nil)
    @chat.with_instructions(SYSTEM_PROMPT)
    generate(initial_prompt(preferences))
  end

  def refine(request)
    generate(<<~PROMPT)
      Follow-up from the user: #{request}

      Suggest #{RECIPE_COUNT} new recipes that take this into account.
      Don't repeat recipes you already suggested in this conversation.
    PROMPT
  end

  private

  def initial_prompt(preferences)
    prompt = <<~PROMPT
      Ingredients I have: #{@chat.ingredients_input}

      Suggest #{RECIPE_COUNT} recipes I can make with these.
    PROMPT
    prompt += "\nPreferences: #{preferences}\n" if preferences.present?
    prompt
  end

  def generate(prompt)
    response = @chat.with_schema(RecipeSchema).ask(prompt)
    save_recipes(parse(response).fetch("recipes", []))
  end

  def parse(response)
    parsed = response.parsed if response.respond_to?(:parsed)
    return parsed if parsed.is_a?(Hash)

    raw = response.content
    return raw if raw.is_a?(Hash)

    JSON.parse(raw.to_s.gsub(/\A\s*```(?:json)?|```\s*\z/, ""))
  rescue JSON::ParserError => e
    raise GenerationError, "The model didn't return valid JSON (#{e.message.truncate(80)})"
  end

  def save_recipes(items)
    raise GenerationError, "The model returned no recipes." if items.blank?

    Recipe.transaction { items.map { |item| build_recipe(item) } }
  rescue ActiveRecord::RecordInvalid => e
    raise GenerationError, "The model returned an invalid recipe: #{e.message}"
  end

  def build_recipe(item)
    nutrition = item["nutrition"] || {}

    recipe = @chat.recipes.create!(
      title:        item["title"],
      description:  item["description"],
      instructions: Array(item["instructions"]),
      prep_minutes: item["prep_minutes"],
      cook_minutes: item["cook_minutes"],
      servings:     item["servings"],
      calories:     nutrition["calories"],
      protein_g:    nutrition["protein_g"],
      carbs_g:      nutrition["carbs_g"],
      fat_g:        nutrition["fat_g"]
    )

    Array(item["ingredients"]).each do |ingredient|
      recipe.recipe_ingredients.create!(
        name:      ingredient["name"],
        quantity:  ingredient["quantity"],
        unit:      ingredient["unit"].presence,
        in_pantry: in_pantry?(ingredient["name"])
      )
    end

    recipe
  end

  def in_pantry?(name)
    name = name.to_s.downcase.strip
    return false if name.blank?
    return true  if STAPLES.include?(name)

    pantry_terms.any? { |term| name.include?(term) || term.include?(name) }
  end

  def pantry_terms
    @pantry_terms ||= @chat.ingredients_input.to_s.downcase
                           .split(/[,\n]/).map(&:strip).reject(&:blank?)
  end
end
