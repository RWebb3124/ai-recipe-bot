class SavedRecipe < ApplicationRecord
  belongs_to :user
  belongs_to :recipe
  validates :recipe_id, uniqueness: { scope: :user_id }
  validates :rating, inclusion: { in: 1..5 }, allow_nil: true
  validates :name, presence: true, uniqueness: { scope: :user_id, case_sensitive: false }
end
