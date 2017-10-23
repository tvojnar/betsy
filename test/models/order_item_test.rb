require "test_helper"
#
# # describe OrderItem do
# #   let(:order_item) { OrderItem.new }
# #
# #   it "must be valid" do
# #     value(order_item).must_be :valid?
# #   end
# # end

describe OrderItem do
  describe "validations" do
    let(:p_id) {Product.first.id}
    let(:o_id) {Order.first.id}
    it "will create a new OrderItem when all fields meet validations" do
      oi = OrderItem.new(product_id: p_id, quantity: 1, order_id: o_id)

      oi.must_be :valid?
    end # makes a new OrderItems when validations are met

    it "requires a quantity" do
      oi = OrderItem.new(product_id: p_id, order_id: o_id)

      oi.wont_be :valid?
      oi.errors.messages.must_include :quantity

    end # it "requires a quantity" do

    it "requires that quantity is an integer" do
      oi = OrderItem.new(product_id: p_id, quantity: "one", order_id: o_id)

      oi.wont_be :valid?
      oi.errors.messages.must_include :quantity
    end

    it "requires that quantity is greater than 0" do
      oi = OrderItem.new(product_id: p_id, quantity: 0, order_id: o_id)
      oi_2 = OrderItem.new(product_id: p_id, quantity: -1, order_id: o_id)

      oi.wont_be :valid?
      oi_2.wont_be :valid?
      oi.errors.messages.must_include :quantity
    end # greater than 0
  end # validations

  describe "relationships" do
    let :o_item { order_items(:one)}
    let :o {orders(:pending)}
    let(:prod) {products(:spider_plant)}
    let (:prod_id) {prod.id}
    let (:o_id) {o.id}
    let(:oi) {OrderItem.new(product_id: prod_id, quantity: 1, order_id: o_id)}

    it "has a product" do
      oi.must_be :valid?
      oi.must_respond_to :product
      oi.product.must_equal prod
      oi.product_id.must_equal prod.id
    end # it "has a product" do

    it "has an order" do
      oi.must_respond_to :order
      oi.order.must_equal o
      oi.order_id.must_equal o.id
    end # it "has an order" do
  end # relationships
end # order_items
