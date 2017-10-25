require "test_helper"

describe ProductsController do
  describe "all users" do

    describe "root" do
      it "returns a success status for root path (all products)" do
        get root_path
        must_respond_with :success
      end

      it "returns a success status when there are no products" do
        Product.destroy_all
        get root_path
        must_respond_with :success
      end
    end

    describe "index" do
      before do
        @merchant = merchants(:tamira)
        @merchant_id = @merchant.id
        @category = categories(:annuals)
        @category_id = @category.id
      end
      it "returns a success status when given a valid merchant_id" do
        get merchant_products_path(Merchant.first)
        must_respond_with :ok
      end

      it "redirects to products path when given a bogus merchant_id" do
        bad_merchant_id = Merchant.last.id + 1
        get merchant_products_path(bad_merchant_id)
        must_respond_with :redirect
        must_redirect_to products_path
      end

      it "when given a merchant id, it directs to the correct page" do
        get products_path(merchant_id: @merchant_id)
        must_respond_with :ok
        merchantid = merchants(:tamira).id
        merchantid.must_equal @merchant_id
      end
      it "when given a merchant id, it lists the products from that merchant" do
        spider_plant = products(:spider_plant)
        get merchant_products_path(@merchant_id)

        merchant = Merchant.find_by(id: @merchant_id)
        merchant.products.must_include spider_plant
      end

      it "when given a cetegory id, it directs to the correct page" do
        get products_path(category_id: @category_id)
        must_respond_with :success
      end

      it "when given a category id, lists the products of the category" do
      end

      it "redirects to products path when given a bogus category id" do
        cat_id = @category_id + 1
        get products_path(category_id: cat_id)
        must_redirect_to products_path
      end

    end

  end

  describe "logged in users (merchants)" do
    before do
      login(merchants(:diane))
    end

    describe "root" do
      it "returns a success status for all products" do
        get root_path
        must_respond_with :success
      end


      it "returns a success status when there are no products" do
        Product.destroy_all
        get root_path
        must_respond_with :success
      end
    end #desc

    describe "new" do
      it "returns a success status" do

        get new_product_path
        must_respond_with :success
      end
    end #desc

    describe "create" do
      it "redirects to merchant_products_path when the product data is valid and adds a work" do
        diane = merchants(:diane)
        product_data = {
          product: {
            merchant: diane,
            name: "string of pearls",
            price: 30.0,
            inventory: 40,
            image_url: 'https://img0.etsystatic.com/135/0/13063062/il_570xN.1001407668_zqhp.jpg'
          }
        }
        product = Product.new(product_data[:product])
        product.must_be :valid?
        product_count = Product.count
        post products_path, params: product_data
        must_respond_with :redirect
        must_redirect_to merchant_products_path(product.merchant.id)
        Product.count.must_equal product_count + 1
      end

      it "renders a new form when the product data is not valid and id does not add a work" do

        invalid_product_data = {
          product: {
            image_url: nil
          }
        }
        start_product_count = Product.count

        Product.new(invalid_product_data[:product]).wont_be :valid?
        post products_path, params: invalid_product_data

        must_respond_with :bad_request
        Product.count.must_equal start_product_count
      end
    end #desc

    describe "show" do
      it "returns a success status when passed a valid id" do
        product_id = Product.first.id
        get product_path(product_id)
        must_respond_with :success
      end

      it "redirects to products path when given a bogus product id" do
        product_id = Product.last.id + 1
        get product_path(product_id)
        must_respond_with :redirect
        must_redirect_to products_path
      end
    end #desc


    describe "edit" do
      it "returns a success status when passed a valid id" do
        product_id = Product.first.id
        get edit_product_path(product_id)
        must_respond_with :found
      end

      it "returns not_found when given a bogus product id" do
        product_id = Product.last.id + 1
        get edit_product_path(product_id)
        must_respond_with :redirect
      end

      it "will not allow access to edit form if logged in Merchant is not the owner of the product" do
        product_id = products(:aloe_vera)
        get edit_product_path(product_id)
        must_respond_with :redirect
      end
    end #desc

    describe "update" do
      before do
        @product = products(:grass)
        @product_data = {
          product: {
            name: @product.name + "exquisite",
            inventory: 2,
            price: 5.50
          }
        }
      end
      it "updates an existing product if it belongs to the logged in merchant" do
        start_product_count = Product.count

        patch product_path(@product), params: @product_data

        must_redirect_to product_path(@product.id)
        # Verify the DB was really modified
        Product.find(@product.id).name.must_equal @product_data[:product][:name]

        start_product_count.must_equal Product.count

      end

      it "will not update product if it does not belong to the logged in merchant and responds with :bad_request" do
        product = products(:aloe_vera)
        product_data = {
          product: {
            name: product.name + " exquisite",
            inventory: 2,
            price: 5.50
          }
        }

        patch product_path(product), params: product_data

        # Verify the DB was really modified
        Product.find(product.id).name.wont_equal product_data[:product][:name]

      end

      it "will not update if data given is invalid" do
        login(merchants(:tamira))
        product = products(:aloe_vera)
        product_data = {
          product: {
            name: nil,
            inventory: 1000,
            price: nil
          }
        }

        patch product_path(product), params: product_data

        # Verify the DB was not modified
        Product.find(product.id).inventory.wont_equal 100

      end
    end
  end

    describe "destroy" do
      before do
        @merchant = merchants(:tamira)
        @merchant_id = @merchant.id

      end
      it "returns success and destroys the work when given a valid product ID AND logged in merchant owns the product" do
        login(@merchant)

        start_count = Product.count

        product = products(:spider_plant)

        # Make assumptions explicit
        product.merchant.must_equal @merchant

        delete product_path(product)
        must_respond_with :redirect

        # NOTE: Why do you expect this to be nill when you're using an existing product (:spider_plant)?
        puts "*" * 50
        puts product.id
        puts "*" * 50
        Product.find_by(id: product.id).must_be_nil
        Product.count.must_equal (start_count - 1)
      end
    # end

    it "will not allow a logged in merchant who is not the owner of the product to delete it" do
      start_count = Product.count
      product = products(:grass)
      puts "*" * 100
      product.merchant.wont_equal @merchant

      delete product_path(product)
      must_respond_with :redirect
      must_redirect_to product_path(product.id)

      Product.count.must_equal start_count
    end

    ## I don't think we really need this test. Should not be possible for a user to get to the point of delete if the product doesn't exist"

    # it "returns not_found when given an invalid product ID" do
    #   merchant = merchants(:kimberley)
    #   login(merchant)
    #   invalid_product_id = Product.last.id + 1
    #   product_count = Product.count
    #   delete product_path(invalid_product_id)
    #   must_respond_with :not_found
    #   Product.count.must_equal product_count
    # end
  end

  describe "visible" do
    before do
      @merchant = merchants(:diane)
      @visible_product = products(:audrey_ficus)
      @invisible_product = products(:ogre_ears)
    end

    it "only allows products that are visible-true to display on products_path (not incl product owner)" do
      login(merchants(:kimberley))
      get merchant_products_path(@merchant.id)

      merchant = Merchant.find_by(id: @merchant.id)

      merchant.products.where(visible: true).must_include @visible_product
      merchant.products.where(visible: true).wont_include @invisible_product

    end

    it "allows product owner to see invisible products on view page" do
      login(@merchant)

      get merchant_products_path(@merchant.id)
      merchant = Merchant.find_by(id: @merchant.id)

      merchant.products.where(visible: true).must_include @visible_product
      merchant.products.where(visible: true).wont_include @invisible_product

      merchant.products.where(visible: false).must_include @invisible_product

    end
  end


  describe "guest users" do
    it "cannot create a new product" do
      start_count = Product.count
      merchant = merchants(:tamira)
      product_data = {
        product: {
          merchant: merchant,
          name: "Fly Trap",
          inventory: 5,
          price: 8.75,
          description: "It eats flies",
          visible: true,
          image_url: "https://images-na.ssl-images-amazon.com/images/I/7120dmLtRmL._SL1000_.jpg"
        }
      }
      product = Product.new(product_data[:product])
      product.must_be :valid?
      post products_path, params: product_data
      must_respond_with :redirect


      start_count.must_equal Product.count
    end


    it "will not allow access to edit form if user is not logged in" do
      product = Product.first
      get edit_product_path(product.id)
      must_respond_with :redirect
      must_redirect_to products_path(product.id)
    end

    it "will not update product if no logged in merchant" do
      product = products(:aloe_vera)
      product_data = {
        product: {
          name: product.name + "exquisite",
          inventory: 2,
          price: 5.50
        }
      }

      patch product_path(product), params: product_data

      # Verify the DB was really modified
      Product.find(product.id).name.wont_equal product_data[:product][:name]
    end
  end
end
