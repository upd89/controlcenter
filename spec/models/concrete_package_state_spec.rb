require 'spec_helper'

RSpec.describe ConcretePackageState, type: :model do
  it "has a valid factory" do
    expect(FactoryGirl.create(:concrete_package_state)).to be_valid
  end

  it "fails without a name" do
    expect( ConcretePackageState.create() ).to be_invalid
  end

  it "passes with a name" do
    expect( ConcretePackageState.create(name: "ASDASD") ).to be_valid
  end
end
