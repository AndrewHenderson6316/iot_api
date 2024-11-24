# lib/tasks/iot_simulation.rake
require 'httparty'
require 'json'

  desc "Simulate IoT API Requests"
  task simulate: :environment do
    # Define the endpoint URL
    endpoint_url = 'http://127.0.0.1:3000/data_entries' # Ensure the endpoint matches your controller

    # Define a method to generate random IoT device data
    def generate_device_data
      custom_ids =["object 1", "name of thing", "this is a name"]
      manufacturer_names = ["Manufacturer A", "Manufacturer B", "Manufacturer C"]
      friendly_names = ["Living Room Sensor", "Bedroom Light", "Kitchen Monitor"]
      categories = ["LIGHT", "TEMPERATURE", "AIR_QUALITY"]
      models = ["Model X", "Model Y", "Model Z"]
      serial_numbers = Array.new(10) { (0...8).map { (65 + rand(26)).chr }.join }
      type_names = ["CARBON MONOXIDE", "TEMPERATURE", "HUMIDITY"]
      scales = ["PPM", "C", "%"]
      puts friendly_names.sample
      {
        data_entry: {
          value: rand(5..15).to_s, # Random value for simulation
          data_type_attributes: {
            typeName: type_names.sample,
            scale: scales.sample
          },
          time_of_sample_attributes: {
            date: Time.now.utc.iso8601
          },
          device_attributes: {
            manufacturer_name: manufacturer_names.sample,
            firmware_version: "1.#{rand(0..9)}.#{rand(0..9)}",
            software_version: "1.#{rand(0..9)}.#{rand(0..9)}",
            model: models.sample,
            serial_number: serial_numbers.sample,
            friendly_name: friendly_names.sample,
            categories: categories.sample,
            custom_id: custom_ids.sample,
            description: "description",
            catagories: "words words words"
          },
          sensor_attributes: {
            manufacturer_name: manufacturer_names.sample,
            serial_number: serial_numbers.sample,
            category: categories.sample,
            created_at: Time.now.utc.iso8601,
            updated_at: Time.now.utc.iso8601
          }
        }
      }
    end

    # Loop to send multiple simulated requests
    10.times do |i|
      # Generate data
      payload = generate_device_data

      # Post data payload
      response = HTTParty.post(endpoint_url, 
                               body: payload.to_json,
                               headers: { 'Content-Type' => 'application/json' })

      puts "Request ##{i + 1} - Status: #{response.code} - Response: #{response.body}"

      # Add a short delay to avoid hitting the API too quickly
      sleep(1)
    end
  end
