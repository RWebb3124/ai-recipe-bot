class CreateSavedRecipes < ActiveRecord::Migration[7.1]
  def change
    create_table :saved_recipes do |t|
      t.references :user, null: false, foreign_key: true
      t.references :recipe, null: false, foreign_key: true
      t.text :notes
      t.integer :rating

      t.timestamps

      t.index [:user_id, :recipe_id], unique: true
    end
  end
end
