class ProductsController < ApplicationController

  def root
    @products = Product.all
  end

  def new
    if find_merchant
      @product = Product.new
    else
      redirect_to root_path
    end
  end

  def create
    if find_merchant #<<necessary? Dl
      @product = Product.new(product_params)
      @product.merchant_id = session[:merchant_id] #<< this will be set in the merchant controller login method
      # ^^ or we could do @product.merchant_id = @login_merchant.id as defined in application controller find_merchant method
      if save_and_flash #<<defined as a method in in application controller
        redirect_to merchant_product_path #redirect might need to be changed based on flow, but idk rn DL
      else
        render :new, status: :bad_request
      end
    else
      redirect_to root_path
    end
  end

  def show
    @product = Product.find_by(id: params[:id])
  end

  def edit
    if find_merchant #<<defined in application_controller, contingent upon OAuth
      #logic to make sure user is signed in as merchant to get to this page
      #if session[:merchant_id]
      @product = Product.find_by(id: params[:id])
    else
      redirect_to root_path
    end

  end

  def update
    @product.update_attributes(product_params)
    if save_and_flash #<<defined as a method in in application controller
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
  if find_merchant
    product = Product.find_by(id: Merchant.find_by(params[:id]).product_id)
    product.destroy
    redirect_to merchants_products_path
    #this is where we might add logic to destroy any reviews and and unshipped OrderItems associated with this Product DL
  end
end

  #logic to make sure user is signed in as merchant to get to this page
  #if session[:merchant_id]?

end

private

def product_params
  return params.require(:product).permit(:name, :inventory, :price, :product_url)
end


end
