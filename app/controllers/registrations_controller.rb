class RegistrationsController < Devise::RegistrationsController
	after_filter :salesforce, only: [:create]
	include ApplicationHelper


	protected


	def salesforce
		if resource.persisted?
			if !user_exists?
				sf_create_contact_and_oppoortunity(resource)
			end
		end
	end

end