class Content < ApplicationRecord
  belongs_to :category
  validates :category, presence: true
  validates :name, presence: true
  # validates :price, presence: true
  validates :location, presence: true
  validates :rating, presence: true
  validates :description, presence: true
end
