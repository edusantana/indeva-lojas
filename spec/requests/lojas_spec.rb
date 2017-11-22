require 'rails_helper'

RSpec.describe "Lojas", type: :request do
  describe "GET /lojas" do
    it "works! (now write some real specs)" do
      get lojas_path
      expect(response).to have_http_status(200)
    end
  end
end
