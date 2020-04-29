FactoryBot.define do
  factory :user do
    sequence(:email) { Faker::Internet.email }
    password { "defaultpw" }
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }

    trait :confirmed do
      before(:create, &:skip_confirmation!)
    end
  end
end
