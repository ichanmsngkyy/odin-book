FactoryBot.define do
  factory :follow do
    association :follower, factory: :user
    association :followed, factory: :user

    # Ensure follower and followed are different
    after(:build) do |follow|
      if follow.follower == follow.followed
        follow.followed = FactoryBot.create(:user)
      end
    end
  end
end
