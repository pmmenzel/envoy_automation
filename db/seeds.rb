# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

full_name = ["Stephanie Breslin", "Josh Marsh", "Lateesha Thomas"].sample


full_name.each do |name|
  User.create(
                name: name,
                email: "#{name.split(' ')[0]}@devbootcamp.com",
                company: "Dev Bootcamp",
                phone: "555-555-5555",
                password: 'password'
    )
end