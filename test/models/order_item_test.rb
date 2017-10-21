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
end # validations

describe "relationships" do
  let(:pending) {orders :pending}
  let(:prod) {products :spider_plant}
  let(:oi) {OrderItem.new(product_id: prod_id, quantity: 1, order_id: o_id)}
  it "has a product" do
    # QUESTION: why can't I access this fixture? Why does it think order_items is a method?
    # o = orders(:pending)
    o_id = pending.id
    # prod = products(:spider_plant)
    prod_id = prod.id
    # oi = OrderItem.new(product_id: prod_id, quantity: 1, order_id: o_id)
    oi.must_be :valid?

    oi.must_respond_to :product
    oi.product.must_equal prod
    oi.product_id.must_equal prod.id

  end # it "has a product" do
end # relationships
