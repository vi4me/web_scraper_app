require 'nokogiri'
require 'open-uri'

class ScraperController < ApplicationController
  def index; end
  # {
  #   "url": "https://pampik.com/catalog/ergo-ryukzak-vasilinka-spelaya-vishnya-rl-len-21450",
  #   "fields": {
  #     "title": ".title",
  #     "price": ".product-info__price-current",
  #     "description": ".description__text",
  #     "meta": ["keywords", "twitter:image"]
  #   }
  # }

  def scrape
    fields = JSON.parse(params[:fields])
    url = fields['url']

    begin
      page = Nokogiri::HTML(URI.open(url))
      result = {}
      fields['fields'].each do |field|
        result[field[0]] = if field[0] == 'meta'
                             {
                               "keywords": page.css(:meta)[18]['content'],
                               "twitter:image": page.css(:meta)[23]['content']
                             }
                           else
                             page.css(field[1]).text.gsub("\n", ' ')
                           end

      end

      render json: { success: true, data: result }
    rescue StandardError => e
      render json: { success: false, error: e.message }
    end
  end
end
