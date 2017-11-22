require "rails_helper"

RSpec.describe LojasController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/lojas").to route_to("lojas#index")
    end

    it "routes to #new" do
      expect(:get => "/lojas/new").to route_to("lojas#new")
    end

    it "routes to #show" do
      expect(:get => "/lojas/1").to route_to("lojas#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/lojas/1/edit").to route_to("lojas#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/lojas").to route_to("lojas#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/lojas/1").to route_to("lojas#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/lojas/1").to route_to("lojas#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/lojas/1").to route_to("lojas#destroy", :id => "1")
    end

  end
end
