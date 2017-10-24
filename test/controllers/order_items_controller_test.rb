require "test_helper"

describe OrderItemsController do
  describe "create" do
    it "will add an order_item and create a new instance of Order if the product exists" do
      start_num_itmes = OrderItem.count
      start_orders = Order.count
      id = Product.first.id
      item_params = {
        order_item: {
          quantity: 1,
          product_id: id
        }
      }

      post order_items_path, params: item_params

      must_respond_with :redirect
      # TODO: change this when we decide where to redirect to!
      must_redirect_to order_current_path
      # check that a new OrderItem was created
      OrderItem.count.must_equal start_num_itmes + 1
      # check that a new Order was created
      Order.count.must_equal start_orders + 1
      # TODO: figure out why this is returning a string! The id # is the same but the 'actual' is a string and the expected is an integer....
      Order.last.order_items.first.product_id.must_equal id
    end

    it "won't add a order_item or save the order if the product doesn't exist" do
      start_num_itmes = OrderItem.count
      start_orders = Order.count
      id = Product.last.id + 1
      item_params = {
        order_item: {
          quantity: 1,
          product_id: id
        }
      }

      post order_items_path, params: item_params
      must_respond_with :not_found
      OrderItem.count.must_equal start_num_itmes
      Order.count.must_equal start_orders
    end # won't add if product doesn't exist

    it "wont add the product if inventory = 0 " do
      start_num_itmes = OrderItem.count
      start_orders = Order.count
      prod = products(:tulip_bulb)
      item_params = {
        order_item: {
          quantity: 1,
          product_id: prod.id
        }
      }

      post order_items_path, params: item_params
      # QUESTION: is not_found the right way to do this?
      must_respond_with :redirect
      flash[:message].must_equal "Sorry, there isn't enough stock. There are 0 Tulip bulb's in stock."
      must_redirect_to product_path(prod)
      OrderItem.count.must_equal start_num_itmes
      Order.count.must_equal start_orders
    end # only add if stock is at 0

    it "won't add the product to the OrderItem if quantity requested > inventory" do
      start_num_itmes = OrderItem.count
      start_orders = Order.count
      prod = products(:spider_plant)
      item_params = {
        order_item: {
          quantity: 11,
          product_id: prod.id
        }
      }

      post order_items_path, params: item_params
      # QUESTION: is not_found the right way to do this?
      must_respond_with :redirect
      # TODO: test the flash message!
      flash[:message].must_equal "Sorry, there isn't enough stock. There are 5 Spider Plant's in stock."
      must_redirect_to product_path(prod)
      OrderItem.count.must_equal start_num_itmes
      Order.count.must_equal start_orders
    end # won't add if quantity < inventory
  end # create

  describe "destroy" do
    it "returns success and deletes the order_item when given a valid order_item ID" do
      count = OrderItem.count
      oi = OrderItem.first

      delete order_item_path(oi)

      must_respond_with :redirect
      must_redirect_to order_current_path
      OrderItem.count.must_equal count - 1
    end # works when given valid order_item

    it "wont delete the OrderItem if the OrderItem doesn't exist" do
      count = OrderItem.count
      id = OrderItem.last.id + 1

      delete order_item_path(id)

      must_respond_with :not_found
      OrderItem.count.must_equal count
    end # wont delete the OrderItem if the OrderItem doesn't exist
  end # destroy

  describe "mark_shipped" do
    it "marks an order item that belongs to a paid order as shipped" do
      #I DONT KNOW WHY THIS IS FAILING, THE SHIPPED STATUS SAVES IN THE MARK_SHIPPED METHODDDDD
      oi_data = {
        oi: {
          order: orders(:paid),
          quantity: 10,
          product: products(:ogre_ears),
        }
      }
      oi = OrderItem.new(oi_data[:oi])
      oi.save
      oi.shipped_status.must_equal false
      patch mark_order_item_path(oi.id)
      must_redirect_to root_path
      OrderItem.find_by(id: oi.id).shipped_status.must_equal true
    end

    it "will not mark an orderitem that belongs to a pending or complete order as shipped" do
      oi = order_items(:one)
      oi.shipped_status.must_equal false
      patch mark_order_item_path(oi.id)
      OrderItem.find_by(id: oi.id).shipped_status.must_equal false

      oi = order_items(:eight)
      oi.shipped_status.must_equal false
      patch mark_order_item_path(oi.id)
      OrderItem.find_by(id: oi.id).shipped_status.must_equal false
    end

    it "marks an orderitem back to false if merchant unmarks order item as shipped" do
      oi_data = {
        oi: {
          order: orders(:paid),
          quantity: 10,
          product: products(:ogre_ears),
        }
      }
      oi = OrderItem.new(oi_data[:oi])
      oi.save
      oi.shipped_status.must_equal false
      patch mark_order_item_path(oi.id)
      must_redirect_to root_path
      OrderItem.find_by(id: oi.id).shipped_status.must_equal true
      patch mark_order_item_path(oi.id)
      OrderItem.find_by(id: oi.id).shipped_status.must_equal false

    end # it
  end # destroy

  describe "update" do
    let(:item_params) {{
      order_item: {
        quantity: 1,
        product_id: prod_id
      }
    }}
    let(:prod) {Product.first}
    let(:prod_name) {prod.name}
    let(:prod_id) {prod.id}
    describe "when OrderItem exists/can be found" do
     describe "when the OrderItem belongs to the current Order" do
       it "will update the quantity when given a valid quantity" do         # Arrange
          # set up the order item edit
           oi_data = {
             order_item: {
               quantity: 4
             }
           }
           # add an OrderItem to the current Order
           post order_items_path, params: item_params
           # find the OrderItem to update
           oi = Order.find_by(id: session[:order_id]).order_items.last
           oi_id = oi.id
           oi.quantity.must_equal 1
           # make sure that the OrderItem starts off with the expected quantity
           Order.find_by(id: session[:order_id]).order_items.last.quantity.must_equal 1

         # Act
          # update the quantity of the OrderItem
          patch order_item_path(oi_id), params: oi_data

         # Assert
           must_respond_with :redirect
           # the quantity of the OrderItem must have been updated
           Order.find_by(id: session[:order_id]).order_items.last.quantity.must_equal 4
           # there will still only be one OrderItem in the Order
           Order.find_by(id: session[:order_id]).order_items.length.must_equal 1
       end # updates when given a valid quantity

       it "won't update if given an invalid quantity ( quantity <= 0)" do
         # set up the order item edit
          oi_data = {
            order_item: {
              quantity: 0
            }
          }
          # add an orderItem to the current order
          post order_items_path, params: item_params
          # find the OrderItem to update and make sure it has the expected quantity
          oi = Order.find_by(id: session[:order_id]).order_items.last
          oi_id = oi.id
          oi.quantity.must_equal 1

        # Act
           # update the OrderItem to have a new quantity
           patch order_item_path(oi_id), params: oi_data

        # Assert
          must_respond_with :redirect
          # the quantity of the OrderItem won't have changed!
          Order.find_by(id: session[:order_id]).order_items.last.quantity.must_equal 1
          # There will still only be one OrderItem in the order!
          Order.find_by(id: session[:order_id]).order_items.length.must_equal 1
       end # won't update if given invalid quantity

       it "won't update the quantity if the provided quantity > inventory" do
         new_quantity = prod.inventory + 1
         oi_data = {
           order_item: {
             quantity: new_quantity,
           }
         }
         # add an orderItem to the current order
         post order_items_path, params: item_params
         # find the OrderItem to update and make sure it has the expected quantity
         oi = Order.find_by(id: session[:order_id]).order_items.last
         oi_id = oi.id
         oi.quantity.must_equal 1

       # Act
          # update the OrderItem to have a new quantity
          patch order_item_path(oi_id), params: oi_data

       # Assert
         must_respond_with :bad_request
         # the quantity of the OrderItem won't have changed!
         Order.find_by(id: session[:order_id]).order_items.last.quantity.must_equal 1
         # There will still only be one OrderItem in the order!
         Order.find_by(id: session[:order_id]).order_items.length.must_equal 1
       end # won't update if q > inventory
     end # when the OI belongs to the current order

     describe "when the OrderItem does not belong to the current Order" do
       it "won't update the quantity if the OrderItem isn't in the current Order" do
         # TODO
         # create an OrderItem that will not be in the current Order
         other_oi = order_items(:one)

         # data to update the OrderItem
         oi_data = {
           order_item: {
             quantity: 2
           }
         }
         # add an orderItem to the current order
         post order_items_path, params: item_params
         # find the OrderItem to update and make sure it has the expected quantity
         oi = Order.find_by(id: session[:order_id]).order_items.last
         oi_id = oi.id
         oi.quantity.must_equal 1

       # Act
          # try to update the OrderItem (that is not in the current Order) to have a new quantity
          patch order_item_path(other_oi), params: oi_data

       # Assert
         must_respond_with :unauthorized
         # the quantity of the OrderItem won't have changed!
         Order.find_by(id: session[:order_id]).order_items.last.quantity.must_equal 1
         # There will still only be one OrderItem in the order!
         Order.find_by(id: session[:order_id]).order_items.length.must_equal 1
       end # if won't update the quantity if the OrderItem isn't in the current Order
     end # when the OrderItem does not belong to the current Order
    end # when OI can be found

    describe "when the OrderItem does not exist" do
      let(:oi_id) {OrderItem.last.id + 1}
      it "won't update and will return not_found the quantity if the OrderItem does not exist" do
        # Arrange
        oi_data = {
          order_item: {
            quantity: 2
          }
        }

        # Act
        post order_items_path, params: item_params
        patch order_item_path(oi_id), params: oi_data

        # Assert
        must_respond_with :not_found
        Order.find_by(id: session[:order_id]).order_items.last.quantity.must_equal 1
        # There will still only be one OrderItem in the order!
        Order.find_by(id: session[:order_id]).order_items.length.must_equal 1
      end # not_found and won't update q
    end # when the OrderItem does not exist
  end # update

end #OrderItemsController
