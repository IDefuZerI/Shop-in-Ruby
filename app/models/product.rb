class Product < ApplicationRecord
  belongs_to :category
  has_many :reviews, dependent: :destroy  # Додаємо асоціацію з відгуками

  validates :name, :price, :category, :weight, :manufacturer, :origin_country, presence: true
  validates :price, numericality: { greater_than_or_equal_to: 0 }
  validates :weight, numericality: { only_integer: true, greater_than: 0 }
  validates :description, length: { maximum: 500 }

  before_create :set_added_at

  private

  def set_added_at
    self.added_at ||= Time.current
  end
end
