class Webhooks::Incoming::JotformWebhook < BulletTrain::Configuration.incoming_webhooks_parent_class_name.constantize
  include Webhooks::Incoming::Webhook
  include Rails.application.routes.url_helpers

  # You can implement your authenticity verification logic in either
  # the newly scaffolded model or controller for your incoming webhooks.
  def verify_authenticity
    true
  end

  def process
    100.times do 
      puts "Webhook fired5"
    end  

    parsed_data = self.data
    puts "**********************************-------------------------"
    parsed_data.each do |key, value|
     # Rails.logger.info "#{key}: #{value}"
      puts "---------------"
      puts "#{key}: #{value}"
    end

    puts "Email::::::::::" + parsed_data['rawRequest']['q6_email'].to_s
    raw_request_data = JSON.parse(parsed_data['rawRequest'])

    # Assuming your parsed_data hash has keys that match the field names or you need to map them manually:
    guest_name = "Evan Testor2" # or parsed_data['q3_attendeeName']
    phone = parsed_data['q5_phoneNumber'] # or parsed_data['q5_phoneNumber']
    email = parsed_data['q6_email'] # or parsed_data['q6_email']
    email = parsed_data['q6_email'] || parsed_data['Email'] || parsed_data['email']
    email = raw_request_data['q6_email']


    email_key = raw_request_data.keys.find { |key| key.include?("email") }
    email_value = raw_request_data[email_key] if email_key

    itinerary_key = raw_request_data.keys.find { |key| key.include?("itinerary") }
    itinerary_value = raw_request_data[itinerary_key] if itinerary_key

    phone_key = raw_request_data.keys.find { |key| key.include?("phoneNumber") }
    phone_value = raw_request_data[phone_key] if phone_key


    # Create a new Medford record
    Medform.create!(
      team_id: 1,
      name: guest_name,
      phone: phone_value,
      email: email_value
    )
    puts "*************************************++++++++++++++++++++++"



  end
end
