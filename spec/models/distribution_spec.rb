require 'spec_helper'

RSpec.describe Distribution, type: :model do
  it "has a valid factory" do
    expect(FactoryGirl.create(:distribution)).to be_valid
  end
end
