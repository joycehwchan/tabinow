class Itinerary < ApplicationRecord
  belongs_to :employee, class_name: "User", optional: true
  belongs_to :client, class_name: "User", optional: true
  has_many :days, dependent: :destroy
  validates :name, presence: true
  validates :status, presence: true
  # validate  :min_budget_cannot_be_higher_than_max_budget
  enum :status, ["draft", "pending", "confirmed", "rejected"], default: :pending
  validates :location, presence: true

  def min_budget_cannot_be_higher_than_max_budget
    return unless min_budget.present? && max_budget.present? && min_budget > max_budget

    errors.add(:max_budget, "Can't be smaller then min budget")
  end
end
