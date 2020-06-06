class UserPolicy < ApplicationPolicy
	class Scope < Scope
		def resolve
			scope
		end
	end

	def index?
		user.admin? || user.manager?
	end

	def show?
		true
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
