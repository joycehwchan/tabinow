class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_many :itineraries_as_employee, class_name: "Itinerary", foreign_key: :employee_id
  has_many :itineraries_as_client, class_name: "Itinerary", foreign_key: :client_id
  validates :name, presence: true
  validates :email, format: { with: /\A.*@.*\.com\z/ }, presence: true
  validates :phone, presence: true
  validates :admin, presence: true
end
