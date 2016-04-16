require 'spec_helper'

RSpec.describe Package, type: :model do
    it "has a valid factory" do
    FactoryGirl.create(:package).should be_valid
  end

  it "is invalid without a name" do
    FactoryGirl.build(:package, name: nil).should_not be_valid
  end
end
