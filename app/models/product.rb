class Product < ApplicationRecord
  belongs_to :merchant
  has_and_belongs_to_many :categories
  has_many :order_items
  has_many :reviews

  validates :name, presence: {message: "A product must have a name."}, uniqueness: true
  validates :price, presence: {message: "A product must have a price."}, numericality: { only_float: true }

end
