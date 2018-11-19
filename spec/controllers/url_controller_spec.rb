require 'rails_helper'
RSpec.describe Api::V1::UrlsController, type: :controller do
  describe "#create" do
    describe "when the URL is in valid format" do
      it "returns a 200 response" do
        post :create, params: { url: "google.com" }
        expect(response.status).to eq(200)
      end

      it "creates a new URL object with correct path and slug" do
        expect { post :create, params: { url: "google.com" } }
          .to change{Url.count}.from(0).to(1)

        url = Url.first

        expect(url.slug).to eq("b")
        expect(url.path).to eq("google.com")
      end
    end

    describe "when the URL is not in a valid format" do
      before(:each) do
        allow(Url).to receive(:valid_url?).and_return(false)
        post :create, params: { url: "bad url" }
      end

      it "returns a 400 status code" do
        expect(response.status).to eq(422)
      end

      it "returns a bad url error message" do
        response_body = ActiveSupport::JSON.decode(response.body).stringify_keys
        expect(response_body).to eq({ "error" => "input url is not valid" })
      end
    end
  end
end
