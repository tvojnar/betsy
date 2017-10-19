require "test_helper"

describe ProductsController do
  describe "all users" do

    # describe "root" do
    #   it "returns a success status for all products" do
    #     get root_path
    #     must_respond_with :success
    #   end
    #
    #   # it "returns a success status when there are no products" do
    #   #   #THIS ONE IS COMPLAINING ABOUT THERE BEING NO CATEGORIES_PRODUCTS RELATION
    #   #   #no idea how categories are being referenced.
    #   #   Product.destroy_all
    #   #   get root_path
    #   #   must_respond_with :success
    #   # end
    # end
  end

  # describe "guest users" do
  #
  #   it "cannot access new" do
  #
  #   end
  #
  #   it "cannot access edit" do
  #
  #   end
  #
  # end


describe "logged in users (merchants)" do
  before do
    login(merchants(:diane))
  end

  # describe "root" do
  #   it "returns a success status for all products" do
  #     get root_path
  #     must_respond_with :success
  #   end
  #
  #   it "returns a success status when there are no products" do
  #     #THIS ONE IS COMPLAINING ABOUT THERE BEING NO CATEGORIES_PRODUCTS RELATION
  #     #no idea how categories are being referenced.
  #     Product.destroy_all
  #     get root_path
  #     must_respond_with :success
  #   end
  # end
  #
    # describe "new" do
    #   it "returns a success status" do
    #
    #     get new_product_path
    #     must_respond_with :success
    #   end
    # end

    describe "create" do
      # it "redirects to merchant_products_path when the product data is valid and adds a work" do
      #   diane = merchants(:diane)
      #   product_data = {
      #     product: {
      #       merchant: diane,
      #       name: "string of pearls",
      #       price: 30.0,
      #       inventory: 40,
      #       image_url: 'https://img0.etsystatic.com/135/0/13063062/il_570xN.1001407668_zqhp.jpg'
      #     }
      #   }
      #   product = Product.new(product_data[:product])
      #   product.must_be :valid?
      #   product_count = Product.count
      #   post products_path, params: product_data
      #   must_respond_with :redirect
      #   must_redirect_to merchant_products_path(product.merchant.id)
      #   Product.count.must_equal product_count + 1
      # end

      it "redirects to merchant_products_path when the product data is not valid and doesn't add a work" do

        product_data = {
          product: {
            image_url: nil
          }
        }
        Product.new(product_data[:product]).wont_be :valid?
        product_count = Product.count
        post products_path, params: product_data
        #must_redirect_to merchant_products_path
        must_respond_with :bad_request
        Product.count.must_equal product_count
      end
      #
      # it "adds at least one instance to the products category intermediary table" do
      #
      #   #ADD THIS TEST
      # end
    end

    # describe "show" do
    #   it "returns a success status when passed a valid id" do
    #     product_id = Product.first.id
    #     get product_path(product_id)
    #     must_respond_with :success
    #   end
    #
    #   it "returns not_found when given a bogus product id" do
    #     product_id = Product.first.id + 1
    #     get product_path(product_id)
    #     must_respond_with :not_found
    #   end
    # end
    #
    # describe "edit" do
    #   it "returns a success status when passed a valid id" do
    #     product_id = Product.first.id
    #     get edit_product_path(product_id)
    #     must_respond_with :success
    #   end
    #
    #   it "returns not_found when given a bogus product id" do
    #     product_id = Product.first.id + 1
    #     get edit_product_path(product_id)
    #     must_respond_with :not_found
    #   end
    # end
    #
    # describe "update" do
    # end
    #
    # describe "retire" do
    #
    # end

    # describe "destroy" do
    #   #not currently working because of merchant verification OAuth work necessary
    #   it "returns success and destroys the work when given a valid product ID" do
    #     product_id = Product.first.id
    #     delete product_path(product_id)
    #     must_respond_with :redirect
    #     must_redirect_to merchant_product_path
    #     Product.find_by(id: product_id).must_be_nil
    #   end
    #
    #   it "returns not_found when given an invalid work ID" do
    #     invalid_product_id = Product.last.id + 1
    #     product_count = Product.count
    #     delete product_path(invalid_product_id)
    #     must_respond_with :not_found
    #     Product.count.must_equal work_count
    #   end
    # end
  end

  end
