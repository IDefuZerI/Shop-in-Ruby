class SessionsController < ApplicationController
  def create
    user = User.find_by(email: user_params[:email])

    if user&.authenticate(user_params[:password])
      session[:user_id] = user.id
      render json: { success: true, message: "Авторизація успішна!" }, status: :ok
    else
      render json: { success: false, error: "Невірний email або пароль" }, status: :unauthorized
    end
  end

  def destroy
    session[:user_id] = nil
    render json: { success: true, message: "Ви вийшли з акаунту" }, status: :ok
  end

  private

  def user_params
    params.require(:user).permit(:email, :password)
  end
end
