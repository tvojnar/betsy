class MerchantsController < ApplicationController
  before_action :require_correct_merchant, only: [:show, :edit, :update]
  def show
    @merchant = Merchant.find_by(id: params[:id])
    if @merchant #!= nil
      @merchant = Merchant.find_by(id: params[:id])
      @merchant_order_items = @merchant.merchant_order_items(@merchant)
      @total_revenue = @merchant.total_revenue(@merchant)
      @pending_revenue = @merchant.pending_revenue(@merchant)
      @paid_revenue = @merchant.paid_revenue(@merchant)
      @shipped_revenue = @merchant.shipped_revenue(@merchant)
      @completed_revenue = @merchant.completed_revenue(@merchant)
      @pending_number = @merchant.pending_number(@merchant)
      @paid_number = @merchant.paid_number(@merchant)
      @shipped_number = @merchant.shipped_number(@merchant)
      @completed_number = @merchant.completed_number(@merchant)
      # @merchant_orders = @merchant.orders(@merchant)
      @merchant_orders = Order.filter_by_merchant(@merchant.id)
      @orders_by_status = @merchant_orders
      if params != nil
        # @orders_by_status = @merchant_orders
        if params[:Status] != nil
          # @orders_by_status = @merchant_orders
          if params[:Status] == "Paid"
            @orders_by_status = Order.filter_by_status(@merchant_orders, "paid")
          elsif params[:Status] == "Pending"
            @orders_by_status = Order.filter_by_status(@merchant_orders, "pending")
          elsif params[:Status] == "Cancled"
            @orders_by_status = Order.filter_by_status(@merchant_orders, "cancled")
          elsif params[:Status] == "Shipped"
            @orders_by_status = Order.filter_by_status(@merchant_orders, "shipped")
          elsif params[:Status] == "All"
            @orders_by_status = @merchant_orders
          end
        end
      end
    else
      render :show, status: :not_found
    end
  end

  def edit
    @merchant = Merchant.find_by(id: params[:id])
    # require 'pry'
    # binding.pry
    if @merchant != nil
      @merchant = Merchant.find_by(id: params[:id])
    else
      render :show, status: :not_found
    end
  end

  def update
    @merchant = Merchant.find_by(id: params[:id])
    if @merchant
      @merchant.update_attributes(merchant_params)
      if save_and_flash(@merchant)
        redirect_to merchant_path(@merchant)
        return
      else
        render :edit, status: :bad_request
        return
      end
    else
      render :show, status: :not_found
    end
  end

  def login
    if session[:merchant_id] || session[:merchant_id] != nil
      head :error
    else
      auth_hash = request.env['omniauth.auth']
      # if session[:merchant_id] = nil

      if auth_hash['uid']
        merchant = Merchant.find_by(provider: params[:provider], uid: auth_hash['uid'])

        if merchant.nil?
          #user has not logged in before
          #create a new record in the DB
          merchant = Merchant.from_auth_hash(params[:provider], auth_hash)
          save_and_flash(merchant)
        else
          flash[:status] = :success
          flash[:message] = "Succesfully logged in as returning merchant #{merchant.name}"
        end # if/else

        session[:merchant_id] = merchant.id

      else
        flash[:status] = :failure
        flash[:message] = "Could not create user from data provided by Github"
      end # if/else
      # end
      redirect_to root_path
    end # if session[:merchant_id]
  end # login


  def logout
    session[:merchant_id] = nil
    session[:order_id] = nil
    flash[:status] = :success
    flash[:message] = "You have successfully logged out"
    redirect_to root_path
  end

  private
  def merchant_params
    return params.require(:merchant).permit(:name, :email)
  end



end
