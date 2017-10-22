require "test_helper"

describe Category do
  let(:category) { Category.new(name: perennials) }
  let(:c_no_name) {Category.new }

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

  end
end
