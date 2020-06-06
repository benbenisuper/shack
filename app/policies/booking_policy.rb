class BookingPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope
    end
  end

  def index?
    user.admin? || user.manager? || record.venue.user == user
  end

  def show?
    user.admin? || user.manager? || record.user == user || record.venue.user == user
  end

  def create?
    true
  end

  def new?
    create?
  end

  def update?
    user.admin? || user.manager? || record.user == user
  end

  def edit?
    update?
  end

  def destroy?
    user.admin? || user.manager? || record.user == user
  end
end
