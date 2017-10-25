require "test_helper"

describe ReviewsController do

  describe "index" do
    before do
      @product = products(:spider_plant)
      @merchant = merchants(:diane)
      login(@merchant)
    end
    it "returns a success status when given a valid product_id " do
      get product_reviews_path(@product.id)
      must_respond_with :ok
    end

    it "redirects to products path when given a bogus product_id" do
      bad_product_id = Product.last.id + 1
      get product_reviews_path(bad_product_id)
      must_respond_with :redirect
      must_redirect_to products_path
    end

    it "still renders the product reviews page even if there are no reviews for that product" do
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

      get product_reviews_path(product.id)
      must_respond_with :success
    end
  end

  describe "new" do
    it "returns a success status" do
      @product = products(:spider_plant)
      login(merchants(:tamira))
      get new_product_review_path(@product)
      must_respond_with :success
    end
  end

  describe "create" do
    before do
      @product = products(:spider_plant)
      login(merchants(:diane))
    end

    it "redirects to product page for that product when the review data is valid and the review has been added" do

      review_data = {
        review: {
          rating: 5,
          description: "Loved it!",
          product_id: @product.id
        }
      }
      review = Review.new(review_data[:review])
      review.must_be :valid?

      proc {
        post product_reviews_path(@product.id), params: review_data }.must_change 'Review.count', +1

        post reviews_path(@product.id), params: review_data

        must_respond_with :redirect
        must_redirect_to product_path(@product.id)

      end

      it "must redirect to product_path when the product belongs to the logged in merchant" do
        @product = products(:grass)
        review_data = {
          review: {
            rating: 5,
            description: "Loved it!",
            product_id: @product.id
          }
        }

        get new_product_review_path(@product)
        post reviews_path(@product.id), params: review_data
        must_redirect_to product_path(@product.id)
      end

      it "must respond with bad request if the review cannot be saved" do

        invalid_review_data = {
          review: {
            rating: 6,  #bad rating
            product_id: @product.id
          }
        }
        start_review_count = Review.count

        Review.new(invalid_review_data[:review]).wont_be :valid?
        post reviews_path(@product.id), params: invalid_review_data

        must_respond_with :bad_request
        Review.count.must_equal start_review_count
      end


    end




  end
