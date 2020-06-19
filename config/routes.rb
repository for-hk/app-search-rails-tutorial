Rails.application.routes.draw do
  resources :ruby_gems, only: [:index, :show]
  post '/search', to: 'ruby_gems#search'
  root 'ruby_gems#index'

end
