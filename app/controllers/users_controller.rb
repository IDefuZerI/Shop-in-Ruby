class UsersController < ApplicationController
  before_action :require_login, only: [:edit, :update] # Захист сторінки профілю
  def create
    @user = User.new(user_params)

    if @user.save
      render json: { success: true, message: "Реєстрація успішна!" }
    else
      render json: { success: false, errors: @user.errors.full_messages }
    end
  end

  def edit
    @user = current_user
  end

  def update
    @user = current_user
    if @user.update(user_params)
      flash[:notice] = "Інформація успішно оновлена"
      redirect_to profile_path
    else
      flash[:alert] = "Виникли помилки при оновленні інформації"
      render :edit
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation, :name, :surname, :phone_number, :address)
  end


  def require_login
    unless logged_in?
      flash[:alert] = "Ви повинні увійти для доступу до цієї сторінки"
      redirect_to login_path
    end
  end
end
