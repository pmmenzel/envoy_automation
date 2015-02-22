require "clearbit"

module ApplicationHelper
	include Databasedotcom::Rails::Controller

	def sf_create_contact_and_oppoortunity
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
		new_contact = User.find_last
		found = Contact.find_by_Email(new_contact.email)
		found != nil
	end

	def cb_lookup
		user = User.find_last
		cb_data = Clearbit::Person.find(email: user.email)

		if cb_data && !cb_data.pending? # === this might be the reason derek wasn't working

			if (cb_data && cb_data.company.name) != nil
				cb_data
			else
				cb_data = Clearbit::Company[domain: user.email.match(/@([^.].+)/).to_s[1..-1]]
			end
		end

	end

	def sf_lookup(cb_data)
		#checks if its person's data or company data then looks up company
		if is_person_data?(cb_data)
			company = cb_data.company
		else
			company = cb_data
		end

		Account.find_by_Name(company.Name)
	end

	def is_person_data?(cb_data)
		cb_data.company != nil
	end

	# When this is called it also creates a contact & opportunity
	def create_sf_account(cb_data)
		user = User.find_last
		if is_person_data?(cb_data)
			company = cb_data.company
		else
			company = cb_data
		end

		account = Account.new
		account.Name = company.name
		account.BillingCity = company.location
		account.NumberOfEmployees = company.employees
		account.Phone = user.phone
		account.OwnerId = OWNER_ID
		account.save
	end

	def create_sf_contact(cb_data)
		# company = Account.find_by_Name(cb_data.company.name)
		# === if company data, then should only fill in information we have
		company = sf_lookup(cb_data)
		user = User.find_last
		contact = Contact.new

		if is_person_data?(cb_data)
			contact.LastName = cb_data.name.familyName
			contact.FirstName = cb_data.name.givenName
			contact.Name = cb_data.name.fullName
			contact.Email = cb_data.email
			contact.MailingCity = cb_data.location
		else
			contact.LastName = user.name.split(' ')[-1]
			contact.FirstName = user.name.split(' ')[0]
			contact.Name = user.name
			contact.Email = user.email
			contact.MailingCity = cb_data.location
		end
		contact.Phone = user.phone
		contact.Account = company.Name
		contact.OwnerId = OWNER_ID
		contact.AccountId = company.Id
		contact.save
	end

	def create_sf_opportunity(cb_data)
		user = User.find_last
		company = sf_lookup(cb_data)
		opportunity = Opportunity.new
		opportunity.Name = "#{company.Name} - #{user.name}"
		opportunity.IsPrivate = false
		opportunity.OwnerId = OWNER_ID
		opportunity.AccountId = company.Id
		opportunity.StageName = "unavailable"
		opportunity.CloseDate = Date.today + 30
		opportunity.save
	end


end
