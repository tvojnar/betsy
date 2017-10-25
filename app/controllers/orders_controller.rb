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

  # def edit
  #   @order = current_order
  #   # @orderitems = current_order.order_items
  #   if @order != nil
  #     @order = session[:order]
  #   else
  #     render :edit, status: :not_found
  #   end
  # end

  # def update
  #   #TODO: MOVE SOME OF THIS STUFF TO CREATE METHOD OF BILLING
  #   @order = current_order
  #   if @order
  #     @order.update_attributes(order_params)
  #     if save_and_flash(@order)
  #       #is this where we want to redirect?
  #       redirect_to root_path
  #       # o = Order.new
  #       #IS THIS THE BEST PLACE TO DO THIS? IT MAKES SENSE FOR THE BUYER BUT NOT THE MERCHANT DL
  #       session[:order_id] = Order.new.id
  #       return
  #     else
  #       render :edit, status: :bad_request
  #       return
  #     end
  #   else
  #     render :edit, status: :not_found
  #   end
  # end

  def submit
    @order = current_order
    # if @order
    #   @order.status = "paid"
    #   @order.date_submitted = DateTime.now
    #   session[:order_id] = nil
    # else
    #   redirect_to order_path(@order.id)
    #   head :not_found
    # end
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

  def complete_order
    order = current_order
    order.status = "paid"
    order.date_submitted = DateTime.now
    order.save
    
    redirect_to order_confirmation_path
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

#DL took out billing attributes and added :status to def order_params permit. the order wasn't saving without it since it was validating its presence
#DL took out the redirect in the submit if loop, as it redirected before the page was displayed...we actually want the button on the submit page to do the redirect/post
#DL changed session[:order_id] = Order.new to session[:order_id] = nil, since current session searches and assigns current_order to Order.new
