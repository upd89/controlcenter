require 'spec_helper'

RSpec.describe ConcretePackageVersion, type: :model do
  it "has a valid factory" do
    expect(FactoryGirl.create(:concrete_package_version)).to be_valid
  end
end
