class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :chats, dependent: :destroy
  has_many :pantry_items, dependent: :destroy
  has_many :saved_recipes, dependent: :destroy
  has_many :favorite_recipes, through: :saved_recipes, source: :recipe
end
