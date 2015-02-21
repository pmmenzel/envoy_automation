require "clearbit"

module AccountsHelper

	def lookup
		person = Clearbit::Person.find(email: 'efrank@genepoint.com')

		if person && !person.pending?
			puts "Name: #{person.name.fullName} Company: #{person.company}"
		end
	end

end
