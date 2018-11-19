require 'rails_helper'
RSpec.describe RedirectUrlController, type: :controller do
  describe "#index" do
    let(:subject) { get :index, params: { slug: slug } }

    describe "when the slug is valid" do
      let(:slug) { "b" }

      describe "and there is not a url corresponding with the slug" do
        let(:url) { FactoryBot.create(:url, id: 2, path: "http://google.com", slug: "c") }

        it "returns a 404 status code" do
          subject
          expect(response.status).to eq(404)
        end
      end

      describe "and there is a url corresponding with the slug" do
        let(:url) { FactoryBot.create(:url, id: 1, path: "http://google.com", slug: "b") }

        it "returns a 301 response status" do
          subject
          expect(response.status).to eq(301)
        end

        it "redirects the user to the URL" do
          expect(subject).to redirect_to("http://google.com")
        end
      end
    end

    describe "when the slug is invalid" do
      let(:slug) { "invalid/slug"  }

      it "returns a 422 status" do
        subject
        expect(response.staut).to eq(422)
      end

      it "returns an error message" do
        subject

        response_body = ActiveSupport::JSON.decode(response.body).stringify_keys
        expect(response_body).to eq({ "error" => "Slug not valid.  Slug must contain only alphanumeric characters" })
      end
    end
  end
end