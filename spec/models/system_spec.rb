require 'spec_helper'

describe System do
  it "has a valid factory" do
    FactoryGirl.create(:system).should be_valid
  end

  it "is invalid without a URN" do
    FactoryGirl.build(:system, urn: nil).should_not be_valid
  end
end
