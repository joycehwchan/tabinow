class Itinerary < ApplicationRecord
  belongs_to :user
  has_many :days, dependent: :destroy
  has_many :contents, through: :days
  validates :name, presence: true
  validates :status, presence: true
  enum :status, ["draft", "pending", "confirmed", "rejected"], default: :pending
  validates :location, presence: true
end
