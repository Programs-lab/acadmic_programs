FactoryBot.define do
  factory :faculty do
    name { Faker::Lorem.word }
    code { Faker::Lorem.word }
  end
end  