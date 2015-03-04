module SFDC_Models
  client = Databasedotcom::Client.new("config/databasedotcom.yml")
  client.sobject_module = "SFDC_Models"
  client.materialize("Account")
  client.materialize("Contact")
  client.materialize("Opportunity")
end