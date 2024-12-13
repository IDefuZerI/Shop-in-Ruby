class CartItemsController < ApplicationController
  before_action :set_cart, only: [:create, :increment, :decrement]
  before_action :set_cart_item, only: [:increment, :decrement]
  before_action :require_login_for_cart, only: [:create, :increment, :decrement]

  def create
    if logged_in?
      product = Product.find(params[:product_id])
      cart_item = @cart.cart_items.find_by(product_id: product.id)

      if cart_item
        cart_item.increment!(:quantity)
      else
        @cart.cart_items.create(product: product, quantity: 1)
      end

      render json: { success: true, message: "Товар успішно додано до кошика" }
    else
      render json: { success: false, message: "Ви повинні увійти для додавання товару до кошика" }, status: :unauthorized
    end
  end

  def increment
    if @cart_item
      @cart_item.increment!(:quantity)
    end
    redirect_to cart_path # Перенаправляємо без повідомлення
  end

  def decrement
    if @cart_item.quantity > 1
      @cart_item.decrement!(:quantity)
    else
      @cart_item.destroy
    end
    redirect_to cart_path # Перенаправляємо без повідомлення
  end

  private

  def set_cart
    @cart = current_user&.cart || current_user&.create_cart
  end

  def set_cart_item
    set_cart
    @cart_item = @cart.cart_items.find_by(id: params[:id])
  end

  def require_login_for_cart
    unless logged_in?
      render json: { success: false, message: "Ви повинні увійти для додавання товару до кошика" }, status: :unauthorized
    end
  end
end
