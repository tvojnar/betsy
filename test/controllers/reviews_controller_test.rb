require "test_helper"

describe ReviewsController do

  describe "index" do
  before do
    @product = products(:spider_plant)
    @merchant = merchants(:diane)
  end
    it "returns a success status when given a valid product_id " do
      login(@merchant)
      get product_reviews_path(@product.id)
      must_respond_with :ok
    end

    it "redirects to products path when given a bogus product_id" do
      bad_product_id = Product.last.id + 1
      get product_reviews_path(bad_product_id)
      must_respond_with :redirect
      must_redirect_to products_path
    end

    it "still renders the page if there are no reviews" do
      diane = merchants(:diane)
      product_data = {
        product: {
          merchant: diane,
          name: "Super Plant",
          price: 30.0,
          inventory: 40,
          image_url: 'https://img0.etsystatic.com/135/0/13063062/il_570xN.1001407668_zqhp.jpg'
        }
      }
      product = Product.create!(product_data[:product])
      # product.must_be :valid?
      # post products_path, params: product_data

      get product_reviews_path(product.id)
      must_respond_with :success
    end
  end

end
