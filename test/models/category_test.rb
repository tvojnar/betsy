require "test_helper"

describe Category do
  let(:category) { Category.new(name: "perennials") }
  let(:c_no_name) {Category.new }
  let(:c_not_uniq_name) { Category.new(name: "perennials") }

  describe "validations" do
    it "creates a new category with a name" do
      c = categories(:annuals)
      result = c.valid?
      result.must_equal true
    end

    it "requires a name to be valid" do
      is_valid = c_no_name.valid?
      is_valid.must_equal false
      c_no_name.errors.messages.must_include :name
    end

    it "requires a unique name to be valid"  do
      category.save
      c_not_uniq_name.valid?.must_equal false
      c_not_uniq_name.errors.messages.must_include :name
    end
  end

  describe "relationships" do
    it "can access products of a category" do
      c = categories(:house_plants)
      c.products << products(:spider_plant)
      c.products << products(:aloe_vera)

      c.products.wont_be :empty?
      c.products.size.must_equal 2

      c.products.must_include products(:spider_plant)
      c.products.must_include products(:aloe_vera)
    end

    it "returns an empty array if category has no products" do
      c = categories(:flower_bulb)

      c.products.must_be :empty?
    end

    #will it be interesting to test if two merchants have the same category?
  end
end
