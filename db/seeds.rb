# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)


require 'csv'

MERCHANT_FILE = Rails.root.join('db', 'seed_data', 'merchants.csv')
puts "Loading raw merchant data from #{MERCHANT_FILE}"

merchant_failures = []
CSV.foreach(MERCHANT_FILE, :headers => true) do |row|
  merchant = Merchant.new
  merchant.name = row['name']
  merchant.email = row['email']
  merchant.uid = row['uid']
  merchant.provider = row['provider']
  puts "Created merchant: #{merchant.inspect}"
  successful = merchant.save
  if !successful
    merchant_failures << merchant
  end
end

puts "Added #{Merchant.count} merchant records"
puts "#{merchant_failures.length} merchants failed to save"


CATEGORY_FILE = Rails.root.join('db', 'seed_data', 'categories.csv')
puts "Loading raw category data from #{CATEGORY_FILE}"

category_failures = []
CSV.foreach(CATEGORY_FILE, :headers => true) do |row|
  category = Category.new
  category.name = row['name']
  puts "Created category: #{category.inspect}"
  successful = category.save
  if !successful
    category_failures << category
  end
end

puts "Added #{Category.count} category records"
puts "#{category_failures.length} categories failed to save"



PRODUCT_FILE = Rails.root.join('db', 'seed_data', 'products.csv')
puts "Loading raw product data from #{PRODUCT_FILE}"

product_failures = []
CSV.foreach(PRODUCT_FILE, :headers => true) do |row|
  category = Category.find_by(name: row['category_name'])

  if category.nil?
    puts "Category does not exist: #{row['category_name']}"
    puts "Product #{row['name']} was not created!!!"
    next
  end

  product = Product.new
  product.name = row['name']
  product.merchant = Merchant.order("RANDOM()").first
  product.inventory = row['inventory']
  product.price = row['price']
  product.categories << Category.find_by(name: row['category_name'])
  product.description = row['description']
  product.visible = row['visible']
  product.image_url = row['image_url']

  puts "Created product: #{product.inspect}"
  successful = product.save

  if !successful
    product_failures << product
  end
end

puts "Added #{Product.count} product records"
puts "#{product_failures.length} products failed to save"



ORDER_FILE = Rails.root.join('db', 'seed_data', 'orders.csv')
puts "Loading raw order data from #{ORDER_FILE}"

order_failures = []
CSV.foreach(ORDER_FILE, :headers => true) do |row|
  order = Order.new
  # order.cc_name = row['cc_name']
  # order.cc_number = row['cc_number']
  # order.cc_exp = rand(10.years).seconds.from_now
  # order.cc_cvv = row['cc_cvv']
  # order.address = row['address']
  # order.zip = row['zip']
  # order.email = row['email']
  order.date_submitted = Date.today
  order.status = row['status']
  puts "Created order: #{order.inspect}"
  successful = order.save
  if !successful
    order_failures << order
  end
end
#
puts "Added #{Order.count} order records"
puts "#{order_failures.length} orders failed to save"



ORDERITEM_FILE = Rails.root.join('db', 'seed_data', 'orderitems.csv')
puts "Loading raw order-item data from #{ORDERITEM_FILE}"

orderitem_failures = []
CSV.foreach(ORDERITEM_FILE, :headers => true) do |row|
  orderitem = OrderItem.new
  orderitem.product_id = Product.order("RANDOM()").first.id
  orderitem.order_id = Order.order("RANDOM()").first.id
  orderitem.quantity = row['quantity']
  # orderitem.cost = row['cost']
  orderitem.shipped_status = row['shipped_status']
  puts "Created orderitem: #{orderitem.inspect}"
  successful = orderitem.save
  if !successful
    orderitem_failures << orderitem
  end
end

puts "Added #{OrderItem.count} orderitem records"
puts "#{orderitem_failures.length} orderitems failed to save"




REVIEW_FILE = Rails.root.join('db', 'seed_data', 'reviews.csv')
puts "Loading raw review data from #{REVIEW_FILE}"

review_failures = []
CSV.foreach(REVIEW_FILE, :headers => true) do |row|
  review = Review.new
  review.product_id = Product.order("RANDOM()").first.id
  review.description = row['description']
  review.rating = rand(1..5)
  puts "Created review: #{review.inspect}"
  successful = review.save
  if !successful
    review_failures << review
  end
end

puts "Added #{Review.count} review records"
puts "#{review_failures.length} review failed to save"
