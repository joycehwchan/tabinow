class ItineraryPolicy < ApplicationPolicy
  class Scope < Scope
    # NOTE: Be explicit about which records you allow access to!
    def resolve
      scope.where(archived: false)
    end
  end

  def create?
    true
  end

  def show?
    # record.employee = user
    true
  end

  def update?
    record.employee = user
  end

  def destroy?
    record.employee = user
  end
end
