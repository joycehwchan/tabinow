class Itinerary < ApplicationRecord
  belongs_to :employee, class_name: "User"
  belongs_to :client, class_name: "User"
end
