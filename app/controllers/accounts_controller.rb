class AccountsController < ApplicationController
	# require_relative "../../lib/clearbit_lookup.rb"
	include AccountsHelper
	include Databasedotcom::Rails::Controller


	def index
  	# In tutorial, they suggest doing it this way but I get a SalesForceError
  	# @accounts = Account.query("Id != NULL LIMIT 20")
  	@accounts = Account.all()[0..19]

  end

  def create
  	# account = Account.all.include?(params[:account])

  	# account = Account.new(params[:account])
  	# account.Name = false
  	# account.IsReminderSet = false
  	# account.Priority = "Normal"
  	# user = User.first
  	# account.OwnerId = user.Id
  	# if (account.save)
  	# 	redirect_to(account, :notice => 'Task was successfully created.')
  	# end
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
