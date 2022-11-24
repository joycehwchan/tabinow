class Itinerary < ApplicationRecord
  belongs_to :employee, class_name: "User", optional: true
  belongs_to :client, class_name: "User", optional: true
  has_many :days, dependent: :destroy
  validates :name, presence: true
  validates :status, presence: true
  validate  :min_budget_cannot_be_higher_than_max_budget
  # validate :itinerary_duration
  enum :status, ["draft", "pending", "confirmed", "rejected"], default: :pending
  validates :location, presence: true

  def min_budget_cannot_be_higher_than_max_budget
    return unless min_budget.present? && max_budget.present? && min_budget > max_budget

    errors.add(:max_budget, "Can't be smaller then min budget")
  end

  def total_days
    if start_date.nil? || end_date.nil?
      days.count
    else
      (end_date - start_date).to_i
    end
  end

  def itinerary_duration
    errors.add(:base, "Minimum itinerary duration 1 Day") if (end_date - start_date_).to_i.zero?
  end
end
