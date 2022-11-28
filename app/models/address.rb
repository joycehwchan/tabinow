class Address < ApplicationRecord
  validates :zipcode, presence: true
  validates :street, presence: true
  validates :city, presence: true
  validates :country, presence: true
  validates :user, presence: true
  belongs_to :user
end
