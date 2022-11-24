class Category < ApplicationRecord
  has_many :contents, dependent: :destroy
  belongs_to :day
  validates :day, presence: true
end
