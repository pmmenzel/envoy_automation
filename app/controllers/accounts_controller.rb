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
  end

  def edit
  	@account = Account.find(params[:id])
  end

  def update
  	@account = Account.find(params[:id])
  	@account.update_attributes(params[:account])
  	render "index"
  end
end
