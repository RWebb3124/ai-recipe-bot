class Chat < ApplicationRecord
  acts_as_chat
  belongs_to :user
  has_many :recipes, dependent: :destroy
end
