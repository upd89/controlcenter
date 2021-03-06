require 'spec_helper'

RSpec.describe "Users", type: :request do

  describe "GET /users" do

    it "redirects to login when not logged in" do
      get users_path
      assert_redirected_to :login
      expect(response).to have_http_status(302)
    end
  end
end
