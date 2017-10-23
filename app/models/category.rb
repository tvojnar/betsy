class Category < ApplicationRecord
  has_and_belongs_to_many :products

  validates :name, presence: {message: "A product must have a name."}, uniqueness: true
end
