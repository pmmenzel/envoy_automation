class AccountsController < ApplicationController
	# require_relative "../../lib/clearbit_lookup.rb"
	include AccountsHelper
	include Databasedotcom::Rails::Controller

  def index
  	# In tutorial, they suggest doing it this way but I get a SalesForceError
  	# @accounts = Account.query("Id != NULL LIMIT 20")
  	@accounts = Account.all()[0..19]
  	lookup
  end

  def create
  	@account = Account.all.include?(params[:account])
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
