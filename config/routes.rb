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
resources :order_items
resources :merchants, only: [:show, :edit, :update]
resources :categories
resources :reviews
resources :billings, only: [:new, :create, :edit, :update]

resources :merchants do
  resources :products
end


resources :products do
  resources :reviews, only: [:index, :new, :create]
end

# NOTE: Dan made orders plural in rout and replaced :id with current since we don't reference :id in these actions. He also took out session[:order_id] from where we reference these routes in the OrdersController.
get 'orders/current', to: "orders#current", as: 'order_current'

get 'orders/current/sure', to: 'orders#sure', as: 'sure_order'
post 'orders/current/submit', to: 'orders#submit', as: 'order_submit'

#CHANGED: DL CHANGED TWO ROUTES ABOVE TO ACCOMODATE THE SURE/SUBMIT

get 'orders/:id/confirmation', to: 'orders#confirmation', as: 'confirm_order'

resources :orders, only: [:index, :show]
# get 'orders/:id/summary', to: 'orders#summary', as: 'order_summary'

patch '/merchant/:id/show', to: "order_items#mark_shipped", as: "mark_order_item"

# show info for current order

resources :categories, only: [:index, :new, :create] do
  resources :products, only: [:index, :new]
end


get '/auth/:provider/callback', to: 'merchants#login', as: 'auth_callback'

# NOTE: I commented out these routes because I don't think we need them since we have the login through OAuth....
# get '/login', to: 'merchants#login', as: 'login'
# post '/login', to: 'merchants#login'
get '/logout', to: 'merchants#logout', as: 'logout'
end
