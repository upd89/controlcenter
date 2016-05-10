require 'spec_helper'

RSpec.describe ConcretePackageState, type: :model do
  it "has a valid factory" do
    expect(FactoryGirl.create(:concrete_package_state)).to be_valid
  end
end
