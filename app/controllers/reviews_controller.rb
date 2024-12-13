class ReviewsController < ApplicationController
  before_action :find_product

  def create
    @review = @product.reviews.new(review_params)
    @review.user = current_user  # Це забезпечить, що кожен відгук має прив'язку до поточного користувача

    if @review.save
      # Якщо відгук успішно збережено, просто відобразити сторінку з новим відгуком
      flash.now[:notice] = 'Відгук успішно додано.'
      render 'products/show_product', status: :ok
    else
      # Якщо помилка, відобразити повідомлення про помилку на тій самій сторінці
      flash.now[:alert] = 'Помилка при додаванні відгуку.'
      render 'products/show_product', status: :unprocessable_entity
    end
  end

  private

  def find_product
    @product = Product.find(params[:product_id])  # знайти продукт через id
  end

  def review_params
    params.require(:review).permit(:rating, :comment)
  end
end
