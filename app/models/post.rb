class Post < ApplicationRecord
  belongs_to :user

  # Validations
  validates :content, presence: true, length: { maximum: 240 }

  # Like model
  has_many :likes

  # Comment mode;
  has_many :comments
end
