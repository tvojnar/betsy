class OrderItemsController < ApplicationController
  def create
    # If this is the first order_item to be added then current_order will return a new instance of Order
    # if we already have a Order for this session then @order will be set to that order
    # we add the order_item from the _add_order_item_to_order form to @order and save the order
    if Product.find_by(params[:product_id])
      @order = current_order
      @item = @order.order_items.new(item_params)
      @order.save
      session[:order_id] = @order.id
      # TODO: later we will want to redirect to a differnt path
      redirect_to root_path
    else
      # QUESTION: is this the right way to check that an order_item won't be added if the product with that ID doesn't exist? 
      head :not_found
    end
  end # create

  private
  def item_params
    params.require(:order_item).permit(:quantity, :product_id)
  end # item_params
end