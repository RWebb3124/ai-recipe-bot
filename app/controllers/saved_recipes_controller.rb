class SavedRecipesController < ApplicationController

  def index
    @saved_recipes = current_user.saved_recipes
                                 .includes(:recipe)
                                 .order(created_at: :desc)
  end

  def create
    recipe = Recipe.owned_by(current_user).find(params[:recipe_id])
    current_user.saved_recipes.find_or_create_by!(recipe: recipe)
    redirect_back fallback_location: recipe, notice: "Recipe saved.", status: :see_other
  end

  def update
    saved_recipe = current_user.saved_recipes.find(params[:id])

    if saved_recipe.update(saved_recipe_params)
      redirect_to saved_recipes_path(anchor: helpers.dom_id(saved_recipe)), notice: "Updated.", status: :see_other
    else
      redirect_to saved_recipes_path,
                  alert: saved_recipe.errors.full_messages.to_sentence,
                  status: :see_other
    end
  end

  def destroy
    current_user.saved_recipes.find_by!(recipe_id: params[:recipe_id]).destroy
    redirect_back fallback_location: saved_recipes_path, notice: "Removed from saved.", status: :see_other
  end

  private

  def saved_recipe_params
    params.require(:saved_recipe).permit(:notes, :rating)
  end
end
