class CalendarPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def show?
  	true
  end

  def update?
    user.admin? || user.manager? || record.venue.user == user
  end
end
