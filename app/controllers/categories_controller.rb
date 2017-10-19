class CategoriesController < ApplicationController
  def index
    # @categories = Category.all
    @categories = Category.where(product_id: params[:product_id])
  end

  def new
    @category = Category.new
  end

  def create
    @category = Category.new(category_params)

    if @category.save

      flash[:success] = :success
      flash[:message] = "#{@category.name} successfully created"
      redirect_to categories_path
    else

      flash.now[:message] = "Failed to create category "
      render :new, status: :bad_request
    end
  end

  def show
  end

  private

  def category_params
    params.require(:category).permit(:name)
  end
end