class CreateRecipeIngredients < ActiveRecord::Migration[7.1]
  def change
    create_table :recipe_ingredients do |t|
      t.references :recipe, null: false, foreign_key: true
      t.string :name
      t.decimal :quantity, precision: 8, scale: 2
      t.string :unit
      t.boolean :in_pantry, null: false, default: false

      t.timestamps
    end
  end
end
