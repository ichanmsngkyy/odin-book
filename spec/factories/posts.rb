FactoryBot.define do
  factory :post do
    content { "Sample post content" }
    association :user
  end
end
