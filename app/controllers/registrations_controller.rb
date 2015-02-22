class RegistrationsController < Devise::RegistrationsController
	# after_filter :test, only: [:create]
	include ApplicationHelper


  protected


  def test
  	resource.persisted?
  	p resource.name
  end


  def after_sign_up_path_for(resource)
  	root_path
  end
end