class ChatsController < ApplicationController
  DEFAULT_MODEL = ENV.fetch("OLLAMA_MODEL", "llama3.2")

  before_action :set_chat, only: :show

  def index
    @chats = current_user.chats.includes(:recipes).order(created_at: :desc)
  end

  def new
    @chat = Chat.new(
      user: current_user,
      ingredients_input: current_user.pantry_items.order(:name).pluck(:name).join(", ")
    )
  end

  def create
    ingredients = chat_params[:ingredients_input].to_s.strip

    if ingredients.blank?
      @chat = Chat.new(user: current_user)
      flash.now[:alert] = "Add at least one ingredient."
      return render :new, status: :unprocessable_entity
    end

    @chat = Chat.create!(
      user: current_user,
      ingredients_input: ingredients,
      model: DEFAULT_MODEL,
      provider: :ollama,
      assume_model_exists: true
    )

    RecipeGenerator.new(@chat).call(preferences: params[:preferences])
    redirect_to @chat
  rescue RubyLLM::Error, Faraday::Error, RecipeGenerator::GenerationError => e
    @chat&.destroy
    redirect_to root_path, alert: "Couldn't reach the recipe helper (#{e.class}). Is Ollama running?"
  end

  def show
    @recipes = @chat.recipes.includes(:recipe_ingredients).order(:id)
    @saved_recipe_ids = current_user.saved_recipes
                                    .where(recipe_id: @recipes.map(&:id))
                                    .pluck(:recipe_id)
  end

  private

  def set_chat
    @chat = current_user.chats.find(params[:id])
  end

  def chat_params
    params.fetch(:chat, {}).permit(:ingredients_input)
  end
end
