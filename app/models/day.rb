class Day < ApplicationRecord
  belongs_to :itinerary
  has_many :categories, dependent: :destroy
  has_many :contents, through: :categories
  validates :number, presence: true
  validates :itinerary, presence: true
end
