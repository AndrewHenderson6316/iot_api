# lib/tasks/iot_simulation.rake
require 'httparty'
require 'json'

namespace :iot do
  desc "Simulate IoT API Requests"
  task simulate: :environment do
    # Define the endpoint URL
    endpoint_url = 'http://127.0.0.1:3000/api/v1/iot_data'

    # Define a method to generate unique IoT device data
    def generate_device_data
      {
        identification: {
          endpointId: {
            scope: {
              type: "sample_type",
              token: "sample_token"
            },
            endpointId: SecureRandom.uuid
          },
          manufacturer: "Sample Manufacturer",
          model: "Sample Model"
        },
        data: [
          {
            type: "CARBON MONOXIDE",
            time: Time.now.utc.iso8601,
            value: {
              value: rand(5..15).to_s,  # Random CO value for simulation
              scale: "PPM"
            }
          },
          {
            type: "TEMPERATURE",
            time: Time.now.utc.iso8601,
            value: {
              value: (15 + rand * 10).round(1).to_s,  # Random temperature
              scale: "CELSIUS"
            }
          }
        ]
      }
    end

    def generate_device_metadata
      {
        endpointId: SecureRandom.uuid,
        manufacturerName: "Sample Manufacturer",
        description: "Smart Light by Sample Manufacturer",
        friendlyName: "Living Room Light",
        categories: ["LIGHT"],
        additionalAttributes: {
          manufacturer: "Sample Manufacturer",
          model: "Sample Model",
          serialNumber: "12345ABC",
          firmwareVersion: "1.0.1",
          softwareVersion: "2.3.4",
          customId: SecureRandom.hex(8)
        },
        capabilities: [],
        connections: [],
        relationships: {},
        registration: {}
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
