require "clearbit"

module AccountsHelper

	def find_or_create
		user = User.find(params[:id])
		p user.company
	end

	def lookup
		person = Clearbit::Person.find(email: 'steven@devbootcamp.com')

		if person && !person.pending?
			# p "About to print steve's company name"
			# p person.company.name
			# p "printing steve's location"
			# p person.location
			# p "trying to print Company location"
			# p person.company.location
		end
	end

end
