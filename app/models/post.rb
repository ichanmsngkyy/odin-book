class Post < ApplicationRecord
  belongs_to :user
  belongs_to :original_post, class_name: "Post", optional: true
  has_many :retweets, class_name: "Post", foreign_key: :original_post_id, inverse_of: :original_post, dependent: :nullify

  # Validations
  validates :content, length: { maximum: 240 }, allow_blank: true
  validates :content, presence: true, unless: :retweet?
  validates :original_post_id, uniqueness: { scope: :user_id, message: "has already been retweeted" }, if: :retweet?
  validate :photos_count_limit
  validate :photos_are_images
  validate :photos_size_limit
  validate :original_post_must_not_be_retweet

  ALLOWED_IMAGE_TYPES = [ "image/jpeg", "image/png", "image/webp" ].freeze
  MAX_PHOTO_SIZE = 5.megabytes
  MAX_PHOTO_COUNT = 4

  # Like model
  has_many :likes

  # Comment model
  has_many :comments

  # Photos
  has_many_attached :photos

  # Retweet
  def retweet?
    original_post_id.present?
  end

  private

  def photos_count_limit
    if photos.attachments.size > MAX_PHOTO_COUNT
      errors.add(:photos, "can have at most #{MAX_PHOTO_COUNT} images")
    end
  end

  def photos_are_images
    photos.each do |photo|
      next if ALLOWED_IMAGE_TYPES.include?(photo.content_type)

      errors.add(:photos, "must be JPEG,PNG or WEBP")
    end
  end

  def photos_size_limit
    photos.each do |photo|
      if photo.blob.byte_size > MAX_PHOTO_SIZE
        errors.add(:photos, "must be smaller than 5MB each")
      end
    end
  end

  def original_post_must_not_be_retweet
    return unless original_post
    return unless original_post.retweet?

    errors.add(:original_post, "must reference an original post")
  end
end
