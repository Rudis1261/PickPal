Rails.application.routes.draw do
  resources :heroes

  get '/scraper', to: 'scraper#index'
  get '/scraper/all', to: 'scraper#all'
  get '/scraper/one/:name', to: 'scraper#one'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
