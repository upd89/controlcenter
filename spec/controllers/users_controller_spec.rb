require 'spec_helper'

RSpec.describe UsersController, type: :controller do
  describe "login mechanism" do

    it "should get forward to login when not logged in" do
      get :index
      assert_redirected_to :login
    end

    #it "should get index when logged in" do
    #  @user = FactoryGirl.create(:user, role: FactoryGirl.build(:role), email: "asd@asd.com", password: "asdasdasd")
    #  login_user_post("asd@asd.com", "asdasdasd") #TODO: doesn't work yet
    #  get 'new', venue_id: 1
    #  assert_response :success
    #end

  end
end
