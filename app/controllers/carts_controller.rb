# app/controllers/carts_controller.rb
class CartsController < ApplicationController
  before_action :require_login # Переконатися, що користувач авторизований

  def show
    @cart = current_user.cart || current_user.create_cart
    @cart_items = @cart.cart_items.includes(:product) # Отримуємо всі елементи корзини з продуктами
  end

  private

  def require_login
    unless logged_in?
      flash[:alert] = "Ви повинні увійти, щоб отримати доступ до цієї сторінки"
      redirect_to login_path
    end
  end
end
