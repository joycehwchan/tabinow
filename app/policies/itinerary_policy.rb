class ItineraryPolicy < ApplicationPolicy
  class Scope < Scope
    # NOTE: Be explicit about which records you allow access to!
    def resolve
      # if record.user == user
      scope.where(client_id: user.id)
      # else
      #   ""
      # end
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
    record.client = user
  end

  def destroy?
    record.client = user
  end

  def download?
    record.client = user
  end

  def preview?
    true
  end

  def move?
    true
  end
end
