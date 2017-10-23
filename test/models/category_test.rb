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
  end
end
