class OrdersController < ApplicationController
  def index
    @orders = Order.all

    # don't want products in here later, but I don't have access to the index page for product so I'm doing it here
    @products = Product.all
    # when a user submits the form a new order_item will be instantiated inside of current_order
    @orderitem = current_order.order_items.new
  end # index

  def show
     @order_items = current_order.order_items
  end # show
end
