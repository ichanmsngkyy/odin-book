class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: [ :github ]

  # Association
  has_many :active_follows, class_name: "Follow", foreign_key: "follower_id"
  has_many :passive_follows, class_name: "Follow", foreign_key: "followed_id"

  # Extracting followers
  has_many :following, through: :active_follows, source: :followed
  has_many :followers, through: :passive_follows, source: :follower

  # Post model
  has_many :posts

  # Like model
  has_many :likes

  # Comment model
  has_many :comments

  # Callbacks
  after_create :send_welcome_email

  require "digest"

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = auth.info.email
      user.password = Devise.friendly_token[0, 20]
      user.avatar_url = auth.info.image
    end
  end

  def profile_picture(size: 200)
    avatar_url.presence || gravatar_url(size: size)
  end

  private

  def gravatar_url(size: 200)
      hash = Digest::MD5.hexdigest(email.downcase.strip)
      "https://www.gravatar.com/avatar/#{hash}?d=identicon&s=#{size}"
  end

  def send_welcome_email
    UserMailer.welcome_email(self).deliver_later
  end
end
