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
    #QUESTION: WHAT IS THE SAFEGUARD FOR THIS? WANT TO MAKE SURE THAT YOU CAN ONLY SEE THE SURE PAGE FOR THE CURRENT ORDER
  end

  #DL MADE THIS METHOD SURE TO MAKE SURE/SUBMIT GET/POST PAIR LIKE NEW/CREATE
  #CHANGED THE SUBMIT VIEW TO SURE AND MADE THE SUBMIT BUTTON POST TO SUBMIT,
  #THEN THE SUBMIT ACTION REDIRECTS TO THE CONFIRMATION PAGE


  def submit
    @order = current_order
    unless @order.order_items.empty?
      @order.status = "paid"
      @order.date_submitted = DateTime.now
      #TODO THIS IS WHERE WE SHOULD HAVE THE QUANTITY DECREASE
      @order.save
      session[:order_id] = nil
      #DL MOVED THIS REDIRECT UP AND HAD IT REDIRECT TO THE CONFIRMATION METHOD
      redirect_to confirm_order_path(@order.id)
      puts ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> #{session[:order_id].class}"
      return
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
      @order_items = @order.find_merchants_oi_in_order(session[:merchant_id])
    else
      head :not_found
    end
  end

#TODO GENERATE CONFIMATION NUMBER FOR ORDER TO CHECK THAT MOST PREVIOUS CURRENT

  def confirmation
    @order = Order.find(params[:id])
    @order_items = @order.order_items
  end

  private

  def order_params
    return params.require(:order).permit(:status)
  end

end
