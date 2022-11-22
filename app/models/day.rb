class Day < ApplicationRecord
  belongs_to :itinerary
  has_many :contents
  validates :number, presence: true
  validates :itinerary, presence: true
end
