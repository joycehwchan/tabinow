class Content < ApplicationRecord
  belongs_to :day
  validates :category, presence: true
  validates :name, presence: true
  validates :price, presence: true
  validates :location, presence: true
  validates :rating, presence: true
  validates :description, presence: true
  validates :api, presence: true
  validates :day, presence: true
end
