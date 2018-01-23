Rails.application.routes.draw do
  get '/', to: 'heroes#index'

  get '/roles', to: 'role#index'
  get '/roles.json', to: 'role#index'
  get '/roles/:id', to: 'role#show'

  get '/scraper', to: 'scraper#index'
  get '/scraper/all', to: 'scraper#all'
  get '/scraper/one/:name', to: 'scraper#one'

  get '/hero/:name', to: 'heroes#one'
  resources :heroes
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
