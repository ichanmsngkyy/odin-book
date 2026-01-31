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
end
