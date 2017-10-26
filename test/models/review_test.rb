require "test_helper"

describe Review do
  let(:rev) { Review.new }
  let(:rev2) { reviews(:good)}


  describe "validations" do
    it "can be created with all fields" do
      valid = rev2.valid?
      valid.must_equal true
    end

    it "requires a rating" do
      valid = rev.valid?
      valid.must_equal false
      rev.errors.messages.must_include :rating
    end

  end

  describe "relationships" do
    it "has a product" do
      rev2.must_respond_to :product
      rev2.product.must_equal products(:spider_plant)
    end
  end

  # it "must be valid" do
  #   value(review).must_be :valid?
  # end
end
