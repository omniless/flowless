require 'rails_helper'

RSpec.describe "Flows", :type => :request do

  let!(:flow) { FactoryGirl.create :flow }

  describe "GET /flows" do
    it "works! (now write some real specs)" do
      get flows_path
      expect(response.status).to be(200)
    end
  end
end
