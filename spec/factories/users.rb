require 'faker'

FactoryGirl.define do
  factory :user do |f|
    f.name { Faker::Internet.user_name }
    f.email { Faker::Internet.email }
    f.salt { "asdasdastr4325234324sdfds" }
    f.crypted_password { Sorcery::CryptoProviders::BCrypt.encrypt("secret", asdasdastr4325234324sdfds) }
  end
end
