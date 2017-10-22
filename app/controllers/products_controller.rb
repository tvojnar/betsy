class ProductsController < ApplicationController
  before_action :find_product, only: [:show, :edit, :update, :destroy, :retire]


  def root #not necessary as it's already in index
    @products = Product.all
  end

  def index
    if merchant_id
      merchant = Merchant.find_by(id: merchant_id)
      if merchant != nil
        @products = merchant.products
      end
    elsif category_id
      category = Category.find_by(id: category_id)
      if category != nil
        @products = category.products
      end
    else
      @products = Product.all
    end
    return @products
  end

  def new
    if find_merchant
      @product = Product.new
      @product.merchant_id = session[:merchant_id]
    else
      redirect_to root_path
    end
  end


  def create
    if find_merchant #<<necessary? Dl
      @product = Product.new(product_params)
      @product.merchant_id = session[:merchant_id] #<< this will be set in the merchant controller login method

      # require 'pry'
      # binding.pry

      # puts "SESSION[:MERCHANT_ID]: #{session}"
      # ^^ or we could do @product.merchant_id = @login_merchant.id as defined in application controller find_merchant method
      # merchant = Merchant.find_by(id: session[:merchant_id])
      if save_and_flash(@product) #<<defined as a method in in application controller
        puts ">>>>>>>>>>>>>>>>> LOGIN_MERCHANT.ID #{@login_merchant.id}"
        redirect_to merchant_products_path(@login_merchant.id) #redirect might need to be changed based on flow, but idk rn DL
      else
        render :new, status: :bad_request
      end
    else
      redirect_to root_path
    end
  end

  def show

  end

  def edit
    if find_merchant #<<defined in application_controller, contingent upon OAuth

    else
      render :root, status: :not_found
    end

  end

  def update
    @product.update_attributes(product_params)
    if save_and_flash(@product) #<<defined as a method in in application controller
      redirect_to merchant_product_path(product.merchant_id) #<<I figure we should redirect to all the merchant's product but lmk if you think differently DL
    else
      render :edit, status: :bad_request
      return
    end
  end


  def retire
    #not sure about this, change the status to retired? add a new column with a migration?
  end

  def destroy
    #tests for destroy don't currently work because I figured that destroy is routed from merchant/:id/product and we don't have a way of tracking merchant without OAuth
    if find_merchant
      merchant_id = Merchant.find_by(id: params[:id]).product_id
      product = Product.find_by(id: merchant_id)
      product.destroy
      redirect_to merchants_products_path
      #this is where we might add logic to destroy any reviews and and unshipped OrderItems associated with this Product DL
    end
  end

  #logic to make sure user is signed in as merchant to get to this page
  #if session[:merchant_id]?

  private

  def product_params
    return params.require(:product).permit(:name, :inventory, :price, :image_url)
  end

  def merchant_id
    if params[:merchant] != nil
      params[:merchant_id] || params[:merchant][:id]
    end
  end

  def category_id
    if params[:category] != nil
      params[:category_id] || params[:category][:id]
    end
  end

  def find_product
    @product = Product.find_by(id: params[:id])
    unless @product
      render :root, status: :not_found
    end
  end
end
