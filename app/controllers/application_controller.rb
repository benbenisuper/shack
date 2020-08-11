class ApplicationController < ActionController::Base
	include Pundit
	before_action :store_user_location!, if: :storable_location?
	before_action :authenticate_user!
	protect_from_forgery with: :exception
	

	# Pundit: white-list approach.
	after_action :verify_authorized, except: [:index, :dashboard], unless: :skip_pundit?
	after_action :verify_policy_scoped, only: :index, unless: :skip_pundit?

	rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized


	def authenticate_admin!
		redirect_to new_user_session_path unless current_user.admin?
	end

	def pundit_user
		current_user
	end

	def user_not_authorized
		flash[:alert] = "You are not authorized to perform this action."
		redirect_to root_path
	end

	def after_sign_in_path_for(resource)
		stored_location_for(resource) || super
	end

	private

	def storable_location?
      request.get? && is_navigational_format? && !devise_controller? && !request.xhr? 
    end

    def store_user_location!
      # :user is the scope we are authenticating
      store_location_for(:user, request.fullpath)
    end

	def skip_pundit?
		devise_controller? || params[:controller] =~ /(^(rails_)?admin)|(^pages$)/
	end
end
