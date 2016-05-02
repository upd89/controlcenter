require 'rails_helper'

RSpec.describe "GroupAssignments", type: :request do
  describe "GET /group_assignments" do
    it "works! (now write some real specs)" do
      get group_assignments_path
      expect(response).to have_http_status(200)
    end
  end
end
