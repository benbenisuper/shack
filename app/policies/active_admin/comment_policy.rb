class ActiveAdmin::CommentPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end
  
  def index?
    user.admin? || user.manager?
  end

  def show?
    user.admin? || user.manager?
  end

  def create?
    user.admin? || user.manager?
  end

  def new?
    create?
  end

  def update?
    user.admin? || user.manager?
  end

  def edit?
    update?
  end

  def destroy?
    user.admin? || user.manager?
  end
end
