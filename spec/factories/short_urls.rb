FactoryBot.define do
  factory :short_url do
    sequence(:original_url) { |n| "https://example.com/page#{n}" }
    sequence(:slug) { |n| "test#{n}" }
    sequence(:title) { |n| "Test URL #{n}" }
    clicks_count { 0 }
    association :user
  end
end
