class Follow < ApplicationRecord
  belongs_to :follower, class_name: "User"
  belongs_to :followed, class_name: "User"

  enum status: { pending: 0, accepted: 1, blocked: 2 }

  validates :follower_id, presence: true, uniqueness: { scope: :followed_id }
  validate :self_follow

  private

  def self_follow
    if follower_id == followed_id
      errors.add(:base, "You can't follow your self")
    end
  end
end
