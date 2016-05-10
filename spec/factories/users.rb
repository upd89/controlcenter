require 'faker'

FactoryGirl.define do
  factory :user do |f|
    f.name Faker::Internet.user_name
    f.email Faker::Internet.email
    f.role
    f.password "asdasdasd"
    f.password_confirmation "asdasdasd"
  end
end
