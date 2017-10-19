Rails.application.routes.draw do
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
resources :orderitems
resources :merchants
resources :categories
resources :reviews

resources :merchants do
  resources :products
end

get '/auth/:provider/callback', to: 'merchants#login', as: 'auth_callback'

get '/login', to: 'merchants#login', as: 'login'
post '/login', to: 'merchants#login'
post '/logout', to: 'merchants#logout', as: 'logout'

end
