FactoryBot.define do
  factory :academic_process do
    name { Faker::Lorem.word }
    year_saces { "1" }
    month_saces { "0" }
    day_saces { "0" }
    year_academic_council { "1" }
    month_academic_council { "0" }
    day_academic_council { "0" }
  end  
end  