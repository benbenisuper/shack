module ActiveAdmin
  module Devise
    class SessionPolicy < ApplicationPolicy
      class Scope < Scope
        def resolve
          scope.all
        end
      end

      def new?
        true
      end

      def destroy?
        true
      end
    end
  end
end