require "test_helper"

describe Product do
  let(:product) {Product.new(merchant: merchants(:diane), name: "Audrey Ficus", inventory: 3, price: 80.00, description: "A small tree with large leaves", visible: true, image_url: " https://www.plantshed.com//media/catalog/product/cache/1/image/9df78eab33525d08d6e5fb8d27136e95/p/s/ps20008_1_1.jpg")}

  let(:p_no_name) {Product.new(merchant: merchants(:tamira), inventory: 2, price: 5.50, description: "A small aloe vera plant", visible: true, image_url: " https://altmanplants.com/wp-content/uploads/Echeveria-Bluebird.jpg")}

  merchant = Merchant.new(provider: "github", uid: 99999, name: "kimberley", email: "test@ada.org")

  let(:p_not_uniq_name) { Product.new(merchant: merchant, name: "Audrey Ficus", inventory: 4, price: 60.00, description: "An evergreen shrub", visible: true, image_url: "https://www.gardenia.net/rendition.square_200/jardin/images/main_picture_54874a7472c1a.jpg") }

  let(:p_not_float) { Product.new(merchant: merchant, name: "Red Cap Cactus", inventory: 10, price: 6, description: "A cactus with a pink flower at the top", visible: true, image_url: "http://www.floristika.com.my/florist/image/cache/data/cactus%20red%20cap-500x612.jpg") }

  let(:p_no_price) { Product.new(merchant: merchant, name: "Red Cap Cactus", inventory: 10, description: "A cactus with a pink flower at the top", visible: true, image_url: "http://www.floristika.com.my/florist/image/cache/data/cactus%20red%20cap-500x612.jpg") }

  let(:p_less_than_zero) { Product.new(merchant: merchant, name: "Red Cap Cactus", inventory: 10, price: -1.0, description: "A cactus with a pink flower at the top", visible: true, image_url: "http://www.floristika.com.my/florist/image/cache/data/cactus%20red%20cap-500x612.jpg") }

  let(:p_no_inventory) { Product.new(merchant: merchant, name: "Red Cap Cactus", price: 30.00, description: "A cactus with a pink flower at the top", visible: true, image_url: "http://www.floristika.com.my/florist/image/cache/data/cactus%20red%20cap-500x612.jpg") }

  let(:p_no_merchant) {Product.new(name: "Aloe Vera", inventory: 2, price: 5.50, description: "A small aloe vera plant", visible: true, image_url: " https://altmanplants.com/wp-content/uploads/Echeveria-Bluebird.jpg")}

  describe "validations" do
    it "can be created with all fields" do
      p = products(:spider_plant)
      result = p.valid?
      result.must_equal true
    end

    it "requires name" do
      is_valid = p_no_name.valid?
      is_valid.must_equal false
      p_no_name.errors.messages.must_include :name
    end

    it "requires a unique name" do
      product.save
      p_not_uniq_name.valid?.must_equal false
      p_not_uniq_name.errors.messages.must_include :name
    end

    it "must have a price" do
      is_valid = p_no_price.valid?
      is_valid.must_equal false
      p_no_price.errors.messages.must_include :price
    end

    it "requires price to be a float" do
      p_not_float.wont_be :valid?
      p_not_float.wont_be_kind_of Float
    end

    it "requires price to be greater than 0" do
    pr = -1.0
    prod = Product.new(merchant: merchant, name: "Red Cap Cactus", inventory: 10, price: pr)

    is_valid = prod.valid?
    is_valid.must_equal false
  end

  # TODO do possibly test for quantity and review??? thoughts
  end

  describe "relationship" do
    it "requires a product must belong to a merchant" do
      is_valid = p_no_merchant.valid?
      is_valid.must_equal false
      p_no_merchant.errors.messages.must_include :merchant
    end

    it "can get merchant from product" do
    products(:aloe_vera).merchant.must_equal merchants(:tamira)
    end
  end

  describe "relationships" do
    it "has many orders through order_items" do
      prod = products(:spider_plant)
      prod_id = prod.id
      o = orders(:pending_2)

      prod.must_respond_to :orders
      prod.orders.wont_include o
      oi = OrderItem.create!(product_id: prod_id, quantity: 1, order: o)
      prod.orders.must_include o
    end # has many orders through order_items
  end # relationships

end
