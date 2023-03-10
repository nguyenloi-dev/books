class OrderItem < ApplicationRecord
  belongs_to :product
  belongs_to :order
  validates :quantity, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validate :product_present
  validate :order_present
  before_save :finalize

  def unit_price
    product.price
  end

  def total_price
    unit_price * quantity
  end

private

  def product_present
    return if product

    errors.add(:product, 'is not valid or is not active.')
  end

  def order_present
    return if order

    errors.add(:order, 'is not a valid order.')
  end

  def finalize
    self[:unit_price] = unit_price
    self[:total_price] = quantity * self[:unit_price]
  end
end
