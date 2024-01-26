Rails.application.routes.draw do
  get '/products', to: 'products#index'
  get '/products/new', to: 'products#new', as: :new_product
  get '/products/:id', to: 'products#show', as: :product
  get '/products/:id/edit', to: 'products#edit', as: :edit_product
  post '/products', to: 'products#create'
  patch '/products/:id', to: 'products#update'
end
