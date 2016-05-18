require 'spec_helper'

RSpec.describe "Systems", type: :request do
  describe "GET /systems" do

    let!(:user) { FactoryGirl.build(:user, password: "asdasdasd", email: "asdasdasd") }

    before(:each) do
      login_user_post("asdasdasd", "asdasdasd")
    end

    #it "works! (now write some real specs)" do
    #  get systems_path
    #  expect(response).to have_http_status(200)
    #end
  end
end
