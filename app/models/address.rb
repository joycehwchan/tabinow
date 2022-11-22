class Address < ApplicationRecord
  validates :zip_code, presence: true
  validates :street, presence: true
  validates :city, presence: true
  validates :country, presence: true
  validates :user_id, presence: true
  belongs_to :user
end
