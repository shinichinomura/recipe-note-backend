class Recipe < ApplicationRecord
  belongs_to :user_account
  has_one_attached :image
end
