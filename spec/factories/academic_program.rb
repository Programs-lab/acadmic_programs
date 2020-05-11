FactoryBot.define do
  factory :academic_program do
    name { Faker::Lorem.word }
    code { Faker::Lorem.word }
    email { Faker::Internet.email }
    faculty
  end
end  