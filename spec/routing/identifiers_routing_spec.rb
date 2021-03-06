require "rails_helper"

describe IdentifiersController, :type => :routing do
  describe "routing" do

    it "routes to #index" do
      expect(get("/identifiers")).to route_to("identifiers#index")
    end

    it "routes to #create" do
      expect(post("/identifiers")).to route_to("identifiers#create")
    end

    it "routes to #update" do
      expect(put("/identifiers/1")).to route_to("identifiers#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(delete("/identifiers/1")).to route_to("identifiers#destroy", :id => "1")
    end

  end
end
