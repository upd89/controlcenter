require 'spec_helper'

RSpec.describe "Users", type: :request do

  describe "GET /users" do

    it "redirects to login when not logged in" do
      get users_path
      assert_redirected_to :login
      expect(response).to have_http_status(302)
    end

    #it "continues when logged in" do
    #  @user = FactoryGirl.create(:user, role: FactoryGirl.build(:role), email: "asd@asd.com", password: "asdasdasd")
    #  login_user_post("asd@asd.com", "asdasdasd") #TODO: doesn't work yet

    #  get users_path
    #  expect(response).to have_http_status(200)
    #end
  end
end
