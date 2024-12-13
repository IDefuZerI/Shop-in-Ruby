# app/models/cart.rb
class Cart < ApplicationRecord
  belongs_to :user
  has_many :cart_items, dependent: :destroy

  # Метод для обчислення загальної суми корзини
  def total_price
    cart_items.includes(:product).map { |item| item.quantity * item.product.price }.sum
  end
end
