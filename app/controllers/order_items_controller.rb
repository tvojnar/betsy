class OrderItemsController < ApplicationController
  def create
    # If this is the first order_item to be added then current_order will return a new instance of Order
    # if we already have a Order for this session then @order will be set to that order
    # we add the order_item from the _add_order_item_to_order form to @order and save the order
    @product = Product.find_by(id: item_params[:product_id])
    if @product
      if item_params[:quantity].to_i <= @product.inventory
        @order = current_order
        @item = @order.order_items.new(item_params)
        @order.save
        session[:order_id] = @order.id
        # TODO: later we will want to redirect to a differnt path
        redirect_to root_path
      else
        flash[:status] = :failure
        flash[:message] = "Sorry, there isn't enough stock. There are #{@product.inventory} #{@product.name}\'s in stock."
        redirect_to product_path(@product)
      end
    else
      # QUESTION: is this the right way to check that an order_item won't be added if the product with that ID doesn't exist?
      flash[:status] = :failure
      flash[:message] = "Sorry, that product does not exist on our site"
      head :not_found
    end
  end # create

  def destroy
    # don't need to know what order you're deleting the order_item from! Just deleting from the order_items table :)
    @item = OrderItem.find_by(id: params[:id])
    if @item
      @item.destroy
      redirect_to order_path(@item.order.id)
    else
      head :not_found
    end
  end

  def mark_shipped
    @item = OrderItem.find_by(id: params[:id])
    if @item.order.status == "paid" || @item.order.status == "shipped"
      if @item.shipped_status == false
        @item.shipped_status = true
        @item.save!
      elsif @item.shipped_status == true
        @item.shipped_status = false
        @item.save!
      end

      @item.order.update_status
      require 'pry'
      binding.pry
      @item.save!
    end
    redirect_back(fallback_location: root_path)
  end

  private
  def item_params
    params.require(:order_item).permit(:quantity, :product_id, :shipped_status)
  end # item_params
end
