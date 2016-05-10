require 'spec_helper'

describe System do
  it "has a valid factory" do
    expect(FactoryGirl.create(:system)).to be_valid
  end

  it "is invalid without a URN" do
    expect(FactoryGirl.build(:system, urn: nil)).to be_invalid
  end
end
