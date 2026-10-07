class Recipe < ApplicationRecord
  belongs_to :chat
  has_many :recipe_ingredients, dependent: :destroy
  has_many :saved_recipes, dependent: :destroy
  validates :title, presence: true
  scope :owned_by, ->(user) { joins(:chat).where(chats: { user_id: user.id }) }
end
