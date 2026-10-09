class Recipe < ApplicationRecord
  belongs_to :chat
  has_many :recipe_ingredients, dependent: :destroy
  has_many :saved_recipes, dependent: :destroy
  validates :title, presence: true
  scope :owned_by, ->(user) { joins(:chat).where(chats: { user_id: user.id }) }

  def total_minutes
    prep_minutes.to_i + cook_minutes.to_i
  end

  def missing_ingredients
    recipe_ingredients.reject(&:in_pantry?)
  end
end
