class PantryItemsController < ApplicationController
  before_action :set_pantry_item, only: %i[edit update destroy]

  def index
    @pantry_items = current_user.pantry_items.order(:name)
  end

  def new
    @pantry_item = current_user.pantry_items.new
  end

  def create
    @pantry_item = current_user.pantry_items.new(pantry_item_params)

    if @pantry_item.save
      redirect_to pantry_items_path, notice: "Added."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @pantry_item.update(pantry_item_params)
      redirect_to pantry_items_path, notice: "Updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @pantry_item.destroy
    redirect_to pantry_items_path, notice: "Removed.", status: :see_other
  end

  private

  def set_pantry_item
    @pantry_item = current_user.pantry_items.find(params[:id])
  end

  def pantry_item_params
    params.require(:pantry_item).permit(:name, :quantity, :unit)
  end
end
