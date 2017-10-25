class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  helper_method :current_order

  protected
  def require_correct_merchant
    @merchant = Merchant.find_by(id: session[:merchant_id])
    if @merchant
      if @merchant != Merchant.find_by(id: params[:id])
        flash[:status] = :failure
        flash[:message] = "You cannot view the account details of another merchant"
        redirect_to root_path
      end # if
    else
      flash[:status] = :failure
      flash[:message] = "You must be logged in to do that"
      redirect_to root_path
    end # if/else
  end # require_correct_merchant

  def current_order
    if session[:order_id]
      Order.find(session[:order_id])
    else
      Order.new
    end # if/else
  end

  def require_login
    @login_merchant = Merchant.find_by(id: session[:merchant_id])
    unless @login_merchant
      flash[:status] = :failure
      flash[:message] = "You must be logged in to do that"
      redirect_to root_path
    end
  end

  # When current_order is called it checks if there is a order_id associated with the session. If there is, it will find that order, if there isn't then it will make a new order



  def save_and_flash(model)
    result = model.save
    if result
      flash[:status] = :success
      flash[:message] = "Sucessfully saved #{model.class}"
    else
      flash.now[:status] = :failure
      flash.now[:message] = "Failed to save #{model.class}"
      flash.now[:details] = model.errors.messages
    end
    return result
  end

  private
  def find_merchant
    if session[:merchant_id] #<<<this will be set in the login method, presumably in the
      #merchants controller after verifying user is logged in as merchant DL
      @login_merchant = Merchant.find_by(id: session[:merchant_id])
    end

  end
end
