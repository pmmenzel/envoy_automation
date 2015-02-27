require "clearbit"

module ApplicationHelper
	include Databasedotcom::Rails::Controller

	def sf_create_contact_and_oppoortunity(new_user)
		company_account = sf_lookup(cb_lookup)
		if company_account
			create_sf_contact(cb_lookup)
		else
			create_sf_account(cb_lookup)
			create_sf_contact(cb_lookup)
			create_sf_opportunity(cb_lookup)
		end

	end

	private

	OWNER_ID = Account.first.OwnerId
	# if users exists on sf, then no need to check anything else as the company would also exist considering the domain name
	def user_exists?
		# new_contact = User.find_last
		found = Contact.find_by_Email(resource.email)
		found != nil
	end

	def cb_lookup
		cb_data = Clearbit::PersonCompany.find(email: resource.email)

		if cb_data && !cb_data.pending?
			cb_data
		end
	end

	def sf_lookup(cb_data)
		#checks if its person's data or company data then looks up company
		Account.find_by_Name(cb_data.company.Name)
	end

	# When this is called it also creates a contact & opportunity
	def create_sf_account(cb_data)
		account = Account.new
		account.Name = cb_data.company.name
		account.BillingCity = cb_data.company.location
		account.NumberOfEmployees = cb_data.company.employees
		account.Phone = resource.phone
		account.OwnerId = OWNER_ID
		account.save
	end

	def create_sf_contact(cb_data)
		company = sf_lookup(cb_data)
		contact = Contact.new

		if cb_data.person
			contact.LastName = cb_data.person.name.familyName
			contact.FirstName = cb_data.person.name.givenName
			contact.Name = cb_data.person.name.fullName
			contact.Email = cb_data.person.email
			contact.MailingCity = cb_data.person.location
		else
			contact.LastName = resource.name.split(' ')[-1]
			contact.FirstName = resource.name.split(' ')[0]
			contact.Name = resource.name
			contact.Email = resource.email
			contact.MailingCity = company.BillingCity
		end
		contact.Phone = resource.phone
		contact.Account = company.Name
		contact.OwnerId = OWNER_ID
		contact.AccountId = company.Id
		contact.Level__c = "Primary"
		contact.save
	end

	def create_sf_opportunity(cb_data)
		company = sf_lookup(cb_data)
		opportunity = Opportunity.new
		opportunity.Name = "#{company.Name} - #{resource.name}"
		opportunity.IsPrivate = false
		opportunity.OwnerId = OWNER_ID
		opportunity.AccountId = company.Id
		opportunity.StageName = "unavailable"
		opportunity.CloseDate = Date.today + 30
		opportunity.save
	end

end
