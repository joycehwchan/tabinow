class Day < ApplicationRecord
  belongs_to :itinerary
  has_many :contents, dependent: :destroy
  validates :number, presence: true
  validates :itinerary, presence: true
end
