FactoryBot.define do
  factory :work_process do
    title { Faker::Lorem.sentence }
    description { Faker::Lorem.paragraph }
    hours { 1 }
  end
end
