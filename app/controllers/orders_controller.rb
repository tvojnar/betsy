class OrdersController < ApplicationController
  def index
    @orders = Order.all
    # don't want products in here later, but I don't have access to the index page for product so I'm doing it here
    @products = Product.all
    # when a user submits the form a new order_item will be instantiated inside of current_order
    @orderitem = current_order.order_items.new
  end # index

  def show
  end # show

  def current
  # if there is a current order (so if anything was added to the cart)
  if session[:order_id]
    @order_items = current_order.order_items
    @order = current_order
  else
    head :not_found
  end
  end # current

  # def sure
  #   @order = current_order
  # end


  def submit
    @order = current_order
    if @order
      @order.status = "paid"
      @order.date_submitted = DateTime.now
      @order.save
      session[:order_id] = nil
    else
      redirect_to confirmation_path(@order.id)
      render :sure
      head :not_found
    end
    puts ">>>>>>>>>>>>>>>>>>>>>>>> @ORDER.STATUS: #{@order.status}"
    puts ">>>>>>>>>>>>>>>>>>>>>>>> @ORDER.ID: #{@order.id}"
  end

  def show
    @order = Order.find(params[:id])
    if @order
      @order = Order.find(params[:id])
      @order_items = @order.order_items
    else
      head :not_found
    end
  end

  def confirmation
    @order = Order.find(params[:id])
    @order_items = @order.order_items
  end

  private

  def order_params
    return params.require(:order).permit(:status)
  end

end
