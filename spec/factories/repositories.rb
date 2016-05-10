FactoryGirl.define do
  factory :repository do
    origin Faker::App.name
    archive Faker::App.name
    component Faker::App.name
  end
end
