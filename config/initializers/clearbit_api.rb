Rails.configuration.clearbit = {
  :secret_key     => ENV['CLEARBIT_KEY']
}

Clearbit.key = Rails.configuration.clearbit[:secret_key]