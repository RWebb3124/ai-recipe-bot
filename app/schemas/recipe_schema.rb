class RecipeSchema < Schematist::Schema
  array :recipes, description: "Recipes the user can make with the ingredients they have" do
    object do
      string  :title
      string  :description, description: "One or two sentence summary of the dish"
      integer :prep_minutes
      integer :cook_minutes
      integer :servings

      array :ingredients do
        object do
          string :name, description: "Ingredient only, e.g. 'spinach', no amounts"
          number :quantity, description: "Numeric amount only, e.g. 0.5 or 2"
          string :unit, description: "e.g. cup, tbsp, tsp, g, ml. Empty string for countable items like eggs"
        end
      end

      array :instructions, of: :string,
            description: "Ordered steps, one action per string, no step numbers"

      object :nutrition do
        integer :calories,  description: "Estimated kcal per serving"
        number  :protein_g, description: "Estimated grams of protein per serving"
        number  :carbs_g,   description: "Estimated grams of carbohydrate per serving"
        number  :fat_g,     description: "Estimated grams of fat per serving"
      end
    end
  end
end
