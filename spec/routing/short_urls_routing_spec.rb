require "rails_helper"

RSpec.describe ShortUrlsController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/short_urls").to route_to("short_urls#index")
    end

    it "routes to #new" do
      expect(get: "/short_urls/new").to route_to("short_urls#new")
    end

    it "routes to #show" do
      expect(get: "/short_urls/1").to route_to("short_urls#show", id: "1")
    end

    it "routes to #edit" do
      expect(get: "/short_urls/1/edit").to route_to("short_urls#edit", id: "1")
    end


    it "routes to #create" do
      expect(post: "/short_urls").to route_to("short_urls#create")
    end

    it "routes to #update via PUT" do
      expect(put: "/short_urls/1").to route_to("short_urls#update", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/short_urls/1").to route_to("short_urls#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/short_urls/1").to route_to("short_urls#destroy", id: "1")
    end
  end
end
