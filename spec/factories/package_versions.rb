FactoryGirl.define do
  factory :package_version do
    sha256 "MyString"
    version "MyString"
    architecture "MyString"
    package nil
    distribution nil
    repository nil
    is_base_version false
  end
end
