class ProductsController < ApplicationController

  def root
    @products = Product.all
  end

  def index
    if merchant_id != nil
      merchant = Merchant.find_by(id: merchant_id)
      @products = merchant.products
    elsif category_id != nil
      category = Category.find_by(id: category_id)
      @products = category.products
    elsif params[:merchant_id] && Merchant.find_by(id: params[:merchant_id]) == nil
      flash[:status] = :failure
      flash[:message] = "Sorry, that merchant was not found."
      redirect_to products_path
      return @products = Product.all
    elsif params[:category_id] && Category.find_by(id: params[:category_id]) == nil
    flash[:status] = :failure
    flash[:message] = "Sorry, that category was not found."
      redirect_to products_path
      return @products = Product.all
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

      if save_and_flash(@product) #<<defined as a method in in application controller
        redirect_to merchant_products_path(@login_merchant.id) #redirect might need to be changed based on flow, but idk rn DL
      else
        render :new, status: :bad_request
      end
    else
      redirect_to root_path
    end
  end

  def show
    @product = Product.find_by(id: params[:id])
    @order_items = current_order.order_items.new
    unless @product
      flash[:status] = :failure
      flash[:message] = "Sorry that product is not in our database."
      redirect_to products_path
      return
    end
  end

  def edit
    @product = Product.find_by(id: params[:id])
    if @product == nil
      flash[:status] = :failure
      flash[:message] = "Sorry, that product was not found!"
      redirect_to products_path
      return
    end
    if find_merchant #<<defined in application_controller, contingent upon OAuth
      #logic to make sure user is signed in as merchant to get to this page
      unless @login_merchant.id == @product.merchant_id
        flash[:status] = :failure
        flash[:message] = "Sorry, you cannot edit another Merchant's products!"
        redirect_to merchant_path(@login_merchant.id)
        return
      end
    else
        flash[:status] = :failure
        flash[:message] = "Sorry, only logged in Merchants can edit products. Please log in to continue."
        redirect_to products_path
        return
    end

  end

  def update
    @product = Product.find_by(id: params[:id])
    @product.update_attributes(product_params)
    if save_and_flash(@product) #<<defined as a method in in application controller
      redirect_to product_path(@product.id) #<<I figure we should redirect to all the merchant's product but lmk if you think differently DL
    else
      render :edit, status: :bad_request
      return
    end
  end


  def retire
    #not sure about this, change the status to retired? add a new column with a migration?
  end

  def destroy
    @product = Product.find_by(id: params[:id])
    if find_merchant
      if @login_merchant.id == @product.merchant_id
        @product.destroy
        flash[:status] = :success
        flash[:message] = "Successfully removed #{@product.name} from your products"
        redirect_to merchant_products_path(@login_merchant.id)
      else
        flash[:status] = :failure
        flash[:message] = "Sorry, you cannot delete this item - merchants only have access to delete their own products!"
        redirect_to product_path(@product.id)
      end
    else
      flash[:status] = :failure
      flash[:message] = "Sorry you must be logged in to do that!"
      redirect_to product_path(@product.id)
    end
      #this is where we might add logic to destroy any reviews and and unshipped OrderItems associated with this Product DL

  end

  #logic to make sure user is signed in as merchant to get to this page
  #if session[:merchant_id]?

  private

  def product_params
    return params.require(:product).permit(:name, :inventory, :price, :description, :image_url)
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
end
