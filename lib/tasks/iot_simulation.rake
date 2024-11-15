# lib/tasks/iot_simulation.rake
require 'httparty'
require 'json'

namespace :iot do
  desc "Simulate IoT API Requests"
  task simulate: :environment do
    # Define the endpoint URL
    endpoint_url = 'http://127.0.0.1:3000/data_entries' # Ensure the endpoint matches your controller

    # Define a method to generate unique IoT device data
    def generate_device_data
      {
        data_entry: { # This wraps the data to match Rails strong parameters
          value: rand(5..15).to_s, # Random value for simulation
          data_type_attributes: {
            typeName: "CARBON MONOXIDE",
            scale: "PPM"
          },
          time_of_sample_attributes: {
            date: Time.now.utc.iso8601
          },
          device_attributes: {
            manufacturer_name: "Sample Manufacturer",
            firmware_version: "1.0.1",
            model: "Sample Model"
          }
        }
      }
    end

    # Define a method to generate metadata for the device
    def generate_device_metadata
      {
        data_entry: { # This wraps the metadata to match Rails strong parameters
          device_attributes: {
            manufacturer_name: "Sample Manufacturer",
            model: "Sample Model",
            serial_number: "12345ABC",
            firmware_version: "1.0.1",
            friendly_name: "Living Room Light",
            categories: "LIGHT"
        }
        }
      }
    end

    # Loop to send multiple simulated requests
    10.times do |i|
      # Generate data
      payload = generate_device_data
      metadata = generate_device_metadata

      # Post data payload
      response = HTTParty.post(endpoint_url, 
                               body: payload.to_json,
                               headers: { 'Content-Type' => 'application/json' })

      puts "Request ##{i + 1} - Status: #{response.code} - Response: #{response.body}"

      # Post metadata payload
      response_metadata = HTTParty.post(endpoint_url,
                                        body: metadata.to_json,
                                        headers: { 'Content-Type' => 'application/json' })

      puts "Metadata Request ##{i + 1} - Status: #{response_metadata.code} - Response: #{response_metadata.body}"

      # Add a short delay to avoid hitting the API too quickly
      sleep(1)
    end
  end
end
