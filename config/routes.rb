Rails.application.routes.draw do
  get 'categories/index'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

#put in only clauses for resources
#nested route for products for a certain category
#nested route for products for a certain merchant

#resources merchants do
  #resources products
#end

#resources categories do
  #resources products
#end
# ^^is this the right syntax? DL
root 'products#root'

resources :products
resources :orders
resources :order_items
resources :merchants
resources :categories
resources :reviews

resources :merchants do
  resources :products
end


get '/category', to: 'categories#show', as: 'filter_category'

resources :categories do
  resources :products
end


get '/auth/:provider/callback', to: 'merchants#login', as: 'auth_callback'

# NOTE: I commented out these routes because I don't think we need them since we have the login through OAuth....
# get '/login', to: 'merchants#login', as: 'login'
# post '/login', to: 'merchants#login'
get '/logout', to: 'merchants#logout', as: 'logout'
end
