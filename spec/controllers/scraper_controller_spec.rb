require 'spec_helper'

RSpec.describe ScraperController, type: :controller do
  describe '#scrape' do
    let(:url) { 'https://www.example.com' }
    let(:fields) do
      {
        "url" => url,
        "fields" => {
          "title" => "title",
          "description" => ".description"
        }
      }.to_json
    end

    context 'when the scraping is successful' do
      let(:html_content) do
        '<html><head><title>Example Title</title></head><body><p class="description">Example Description</p></body></html>'
      end

      before { stub_request(:get, url).to_return(body: html_content) }

      it 'returns success response with scraped data' do
        post :scrape, params: { fields: fields }

        expect(response).to have_http_status(:success)
        expect(JSON.parse(response.body)).to eq(
                                               { "success" => true,
                                                 "data" => {
                                                   "title" => "Example Title",
                                                   "description" => "Example Description"
                                                 }
                                               }
                                             )
      end
    end

    context 'when the scraping fails' do
      before { allow(URI).to receive(:open).and_raise(StandardError, 'Failed to open URL') }

      it 'returns failure response with error message' do
        post :scrape, params: { fields: fields }

        expect(response).to have_http_status(:success)
        expect(JSON.parse(response.body)).to eq(
                                               { "success" => false,
                                                 "error" => "Failed to open URL"
                                               }
                                             )
      end
    end
  end
end