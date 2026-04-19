class Comment < ApplicationRecord
  belongs_to :post
  belongs_to :user

  validates :content, presence: true, length: { maximum: 240 }
  validate :photo_is_image
  validate :photo_size_limit

  ALLOWED_IMAGE_TYPES = [ "image/jpeg", "image/png", "image/webp" ].freeze
  MAX_PHOTO_SIZE = 5.megabytes

  # Active Storage
  has_one_attached :photo

  private

  def photo_is_image
    return unless photo.attached?
    return if ALLOWED_IMAGE_TYPES.include?(photo.content_type)

    errors.add(:photo, "must be JPEG, PNG, or WEBP")
  end

  def photo_size_limit
    return unless photo.attached?
    return if photo.blob.byte_size <= MAX_PHOTO_SIZE

    errors.add(:photo, "must be smaller than 5MB")
  end
end
