Rails.application.routes.draw do
  resources :todos
  get '/scraper', to: 'todos#scraper'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
