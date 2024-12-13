# app/models/user.rb
class User < ApplicationRecord
  has_one :cart, dependent: :destroy

  # Валідація для обов'язкових полів
  validates :email, presence: true, uniqueness: true
  validates :password, presence: true, on: :create
  validates :password, confirmation: true, allow_blank: true, on: :update

  # Хешування пароля
  has_secure_password

  # Встановлення значення за замовчуванням для role
  before_validation :set_default_role, on: :create

  private

  def set_default_role
    self.role ||= "customer"
  end
end
