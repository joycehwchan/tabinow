class UnusedContent < ApplicationRecord
  belongs_to :itinerary
  validates :name, presence: true
  validates :price, presence: true
  validates :location, presence: true
  validates :rating, presence: true
  validates :description, presence: true
  has_one_attached :image
  geocoded_by :location
  after_validation :geocode, if: :will_save_change_to_location?
  # geocoded_by :location
  # after_validation :geocode, if: :will_save_change_to_location?
end
