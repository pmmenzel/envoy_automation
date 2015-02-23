class AccountsController < ApplicationController
	include ApplicationHelper
	include Databasedotcom::Rails::Controller


	def index
    @accounts = Account.all()[0..19]
  end

  def create

  end

  def show
    @account = Account.find(params[:id])
    @contacts = Contact.all
    @opportunities = Opportunity.all
  end

end
