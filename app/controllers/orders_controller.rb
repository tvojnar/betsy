class OrdersController < ApplicationController
  def index
    @orders = Order.all
    # don't want products in here later, but I don't have access to the index page for product so I'm doing it here
    @products = Product.all
    # when a user submits the form a new order_item will be instantiated inside of current_order
    @orderitem = current_order.order_items.new
  end # index

  def current
  # if there is a current order (so if anything was added to the cart)
  if session[:order_id]
    @order_items = current_order.order_items
    @order = current_order
  else
    head :not_found
  end
  end # current

  def sure
    @order = current_order
    unless @order
      redirect_to order_current_path
    end
  end

  def submit
    @order = current_order
    unless @order.order_items.empty?
      @order.status = "paid"
      @order.date_submitted = DateTime.now
      if check_inventory(@order)
        @order.save
        session[:order_id] = nil
        @order.products.reduce_inventory(@order)
        #QUESTION is this right? ^^
        redirect_to confirm_order_path(@order.id)
        return
      else
        flash[:status] = :failure
        flash[:message] = "There is not enough inventory to fulfill your order, please select quantity"
        redirect_to order_current_path
        return
      end
    else
      flash[:status] = :failure
      flash[:message] = "You cannot checkout with 0 items"
      render :sure
      head :not_found
    end
  end

  def show
    @order = Order.find_by(id: params[:id])
    if @order
      @order = Order.find(params[:id])
      @merchant = Merchant.find_by(id: session[:merchant_id])
      @order_items = @order.find_merchants_oi_in_order(session[:merchant_id])
    else
      head :not_found
    end
  end

#TODO GENERATE CONFIMATION NUMBER FOR ORDER TO CHECK THAT MOST PREVIOUS CURRENT

  def confirmation
    if session[:order_id] == nil
      @order = Order.find(params[:id])
      if @order.status == "paid" && @order.date_submitted
        @order_items = @order.order_items
      end
    else
      flash[:status] = :failure
      flash[:message] = "Order status did not update to paid"
      redirect_to order_current_path
    end
  end

  private

  def order_params
    return params.require(:order).permit(:status)
  end

  def check_inventory(order)
    order.order_items.each do |item|
      if item.quantity> item.product.inventory
        return false
      end
    end
    return true
  end

end
