require 'spec_helper'

RSpec.describe Repository, type: :model do
  it "has a valid factory" do
    expect(FactoryGirl.create(:repository)).to be_valid
  end
end
