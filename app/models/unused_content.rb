class UnusedContent < ApplicationRecord
  validates :category, presence: true
  validates :name, presence: true
  # validates :price, presence: true
  validates :location, presence: true
  validates :rating, presence: true
  validates :description, presence: true
  has_one_attached :image
end
