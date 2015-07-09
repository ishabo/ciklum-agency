require "spec_helper"

describe BonusSchemesController do
  describe "routing" do

    it "routes to #index" do
      get("/bonus_schemes").should route_to("bonus_schemes#index")
    end

    it "routes to #new" do
      get("/bonus_schemes/new").should route_to("bonus_schemes#new")
    end

    it "routes to #show" do
      get("/bonus_schemes/1").should route_to("bonus_schemes#show", :id => "1")
    end

    it "routes to #edit" do
      get("/bonus_schemes/1/edit").should route_to("bonus_schemes#edit", :id => "1")
    end

    it "routes to #create" do
      post("/bonus_schemes").should route_to("bonus_schemes#create")
    end

    it "routes to #update" do
      put("/bonus_schemes/1").should route_to("bonus_schemes#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/bonus_schemes/1").should route_to("bonus_schemes#destroy", :id => "1")
    end

  end
end
