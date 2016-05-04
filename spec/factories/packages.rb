require 'faker'

FactoryGirl.define do
  factory :package do |f|
    f.name Faker::App.name
    f.section Faker::Lorem.word
    f.homepage Faker::Internet.url
    f.summary Faker::Lorem.paragraph
  end
end
