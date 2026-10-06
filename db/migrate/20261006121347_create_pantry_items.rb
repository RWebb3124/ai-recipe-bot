class CreatePantryItems < ActiveRecord::Migration[7.1]
  def change
    create_table :pantry_items do |t|
      t.references :user, null: false, foreign_key: true
      t.string :name
      t.decimal :quantity, precision: 8, scale: 2
      t.string :unit

      t.timestamps
    end
  end
end
