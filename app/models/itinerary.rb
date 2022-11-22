class Itinerary < ApplicationRecord
  belongs_to :employee, class_name: "User"
  belongs_to :client, class_name: "User"
  has_many :days
  has_many :contents, through: days
  validates :name, presence: true
  validates :employee, presence: true
  validates :client, presence: true
  validates :status, presence: true
  validates :location, presence: true
end
