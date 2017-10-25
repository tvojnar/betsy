class CategoriesController < ApplicationController
  before_action :require_login, only: [:new, :create]

  def index
    @categories = Category.all
  end

  def new
    @category = Category.new
  end

  def create
    @category = Category.new(category_params)

    if @category.save

      flash[:status] = :success
      flash[:message] = "#{@category.name} successfully created"

      redirect_to merchant_products_path(@login_merchant)

    else
      flash[:status] = :failure
      flash[:message] = "Failed to create category "
      render :new, status: :bad_request
    end
  end

  private

  def category_params
    params.require(:category).permit(:name)
  end
end
