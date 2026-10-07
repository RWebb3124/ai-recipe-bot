class CreateRecipeGenerators < ActiveRecord::Migration[7.1]
  def change
    create_table :recipe_generators do |t|

      t.timestamps
    end
  end
end
