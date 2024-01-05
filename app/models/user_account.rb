class UserAccount < ApplicationRecord
  has_secure_password

  class EmailUniquenessValidator < ActiveModel::EachValidator
    def validate_each(record, attribute, value)
      if UserAccount.where(email: value, resigned_at: nil).exists?
        record.errors.add(attribute, :taken)
      end
    end
  end

  has_many :recipes

  validates :display_name,
    presence: true,
    length: { maximum: 16 }

  validates :email,
    presence: true,
    length: { maximum: 255 },
    format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i },
    email_uniqueness: true

  validates :password,
    presence: true,
    length: { minimum: 8, maximum: 16 },
    format: { with: /\A[a-zA-Z0-9]+\z/ }

  validates :registered_at,
    presence: true

end
