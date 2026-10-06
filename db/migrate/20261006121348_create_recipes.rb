class CreateRecipes < ActiveRecord::Migration[7.1]
  def change
    create_table :recipes do |t|
      t.references :chat, null: false, foreign_key: true
      t.string :title
      t.text :description
      t.json :instructions
      t.integer :prep_minutes
      t.integer :cook_minutes
      t.integer :servings
      t.integer :calories
      t.decimal :protein_g, precision: 8, scale: 2
      t.decimal :carbs_g, precision: 8, scale: 2
      t.decimal :fat_g, precision: 8, scale: 2

      t.timestamps
    end
  end
end
