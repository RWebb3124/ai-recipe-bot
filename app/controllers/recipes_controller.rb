class RecipesController < ApplicationController
  def show
    @recipe = Recipe.owned_by(current_user)
                    .includes(:recipe_ingredients)
                    .find(params[:id])
    @saved_recipe = current_user.saved_recipes.find_by(recipe: @recipe)
  end
end
