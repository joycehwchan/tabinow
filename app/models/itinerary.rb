class Itinerary < ApplicationRecord
  belongs_to :client, class_name: "User"
  belongs_to :employee, class_name: "User"
  has_many :days, dependent: :destroy
  has_many :contents, through: :days
  validates :name, presence: true
  validates :status, presence: true
  enum :status, ["draft", "pending", "confirmed", "rejected"], default: :pending
  validates :location, presence: true
end
