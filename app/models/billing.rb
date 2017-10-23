class Billing < ApplicationRecord
  belongs_to :order

  validates :cc_name, presence: true
  validates :cc_number, presence: true
  validates :cc_cvv, presence: true
  validates :cc_exp, presence: true
  validates :address, presence: true
  validates :email, presence: true
  validates :zip, presence: true
  validates :order_id, presence: true
end
