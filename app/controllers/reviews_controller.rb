class ReviewsController < ApplicationController

  def index
    @product = Product.find_by(id: params[:product_id])
    @reviews = Review.all.find_by(product_id: @product.id)
  end

  def new
    @product = Product.find_by(id: params[:product_id])
    @review = Review.new(product: @product)
  end

  def create
    @review = Review.new(review_params)
    @product = Product.find_by(id: params[:review][:product_id])

    product_merchant = Merchant.find_by(id: @product.merchant_id)

    if find_merchant
      if @login_merchant.id == product_merchant.id
        flash[:status] = :failure
        flash[:message] = "Sorry, you cannot review your own products."
        redirect_to product_path(@product.id)
        return
      end
    end

      if @review.save
        flash[:status] = :success
        flash[:message] = "Thank you for your review!"
        redirect_to product_path(@review.product_id)
        return
      else
        flash[:status] = :failure
        flash[:message] = "Sorry, your review could not be saved."
        puts ">>>>>>>>>>> DPR: Failed to save review:"
        puts "#{@review.errors.messages}"
        redirect_to products_path
        return
      end

  end


    private

    def review_params
      params.require(:review).permit(:rating, :description, :product_id)
    end

end
