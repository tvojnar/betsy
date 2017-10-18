class ReviewController < ApplicationController

  def new
    @review = Review.new
  end

  def create

    #can use @login_merchant from application controller for current merchant DL
    current_merchant = Merchant.find_by(id: session[:logged_in_user])
    product_merchant = Merchant.find_by(id: params[:product][:merchant_id])

    unless current_merchant == nil
      if current_merchant.id == product_merchant.id
        flash[:status] = :failure
        flash[:message] = "Sorry, you cannot review your own products."
        redirect_to product_path(product_id)
        return
      end
    end

    @review = Review.new(review_params)

    if @review.save
      flash[:status] = :success
      flash[:message] = "Thank you for your review!"
      redirect_to product_path(product_id)
      return
    else
      flash[:status] = :failure
      flash[:message] = "Sorry, your review could not be saved."
      redirect_to products_path
      return
    end

  end



  private

    def review_params
      params.require(:review).permit(:rating, :description, :product_id)
    end
end
