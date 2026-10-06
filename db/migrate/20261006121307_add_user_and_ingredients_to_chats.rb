class AddUserAndIngredientsToChats < ActiveRecord::Migration[7.1]
  def change
    add_reference :chats, :user, null: false, foreign_key: true
    add_column :chats, :ingredients_input, :text
  end
end
