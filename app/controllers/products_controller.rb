class ProductsController < ApplicationController
  before_action :require_admin, only: [:new, :create]

  def new
    @product = Product.new
    @categories = Category.all
  end

  def create
    @product = Product.new(product_params)
    if @product.save
      redirect_to products_path, notice: 'Товар успішно додано.'
    else
      render :new
    end
  end

  def index
    # Завантажуємо всі категорії для фільтрів
    @categories = Category.all

    # Якщо обрано фільтр за категорією, фільтруємо продукти
    if params[:category]
      @products = Product.where(category_id: params[:category])
    else
      @products = Product.all
    end
  end

  def show_product
    @product = Product.find(params[:id])
    @reviews = @product.reviews
    @review = @product.reviews.new  # Це створює порожній відгук для форми
  end

  private

  def require_admin
    unless logged_in? && current_user.role.downcase == 'admin'
      redirect_to root_path, alert: 'Доступ заборонено'
    end
  end

  def product_params
    params.require(:product).permit(:name, :description, :price, :weight, :ingredients, :manufacturer, :origin_country, :image, :category_id)
  end
end
