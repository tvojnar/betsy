require "test_helper"
#
# # describe OrderItem do
# #   let(:order_item) { OrderItem.new }
# #
# #   it "must be valid" do
# #     value(order_item).must_be :valid?
# #   end
# # end

describe "validations" do
  it "requires a quantity" do
    # TODO
  end # it "requires a quantity" do

  it "requires that quantity is an integer" do
    # TODO
  end

  it "requires that quantity is greater than 0" do
  end # greater than 0 

end # validations

describe "relationships" do
  let(:o) {orders :pending}
  let(:prod) {products :spider_plant}
  # change this to access a fixture once fixtures are working in model tests!
  let(:oi) {OrderItem.new(product_id: prod_id, quantity: 1, order_id: o_id)}
  it "has a product" do
    # QUESTION: why can't I access this fixture? Why does it think order_items is a method?
    # o = orders(:pending)
    # o_id = o.id
    # prod = products(:spider_plant)
    prod_id = prod.id
    # oi = OrderItem.new(product_id: prod_id, quantity: 1, order_id: o_id)
    oi.must_be :valid?

    oi.must_respond_to :product
    oi.product.must_equal prod
    oi.product_id.must_equal prod.id
  end # it "has a product" do

  it "has an order" do
    # TODO: be able to access fixtures so these tests pass!
    o_id = o.id

    oi.must_respond_to :order
    oi.order.must_equal o
    oi.order_id.must_equal o.id
  end # it "has an order" do
end # relationships
