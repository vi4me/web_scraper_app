Rails.application.routes.draw do
  root 'scraper#index'
  post 'scraper/scrape', to: 'scraper#scrape', as: 'scrape'
end
