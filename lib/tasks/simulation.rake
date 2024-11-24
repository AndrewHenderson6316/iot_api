require 'httparty'
require 'json'

# Define the devices and sensors
devices = [
  {
    custom_id: "device_01",
    manufacturer_name: "manufacturer1",
    friendly_name: "My Device 1",
    model: "Model X",
    serial_number: "d014321",
    firmware_version: "v1.0",
    software_version: "v1.1",
    categories: "temperature air_quality",
    description: "device that captures temperature and air quality",
    sensors: [
      { manufacturer_name: "manufacturer1", serial_number: "s014321", category: "temperature" },
      { manufacturer_name: "manufacturer2", serial_number: "s024321", category: "air quality" }
    ]
  },
  {
    custom_id: "device_02",
    manufacturer_name: "manufacturer1",
    friendly_name: "My Device 2",
    model: "Model Y",
    serial_number: "d024321",
    firmware_version: "v2.0",
    software_version: "v2.1",
    categories: "temperature air_quality",
    description: "device that captures temperature and air quality",
    sensors: [
      { manufacturer_name: "manufacturer3", serial_number: "s034321", category: "temperature" },
      { manufacturer_name: "manufacturer4", serial_number: "s044321", category: "air quality" }
    ]
  },
  {
    custom_id: "device_03",
    manufacturer_name: "manufacturer1",
    friendly_name: "My Device 3",
    model: "Model Z",
    serial_number: "d034321",
    firmware_version: "v3.0",
    software_version: "v3.1",
    categories: "temperature air_quality",
    description: "device that captures temperature and air quality",
    sensors: [
      { manufacturer_name: "manufacturer5", serial_number: "s054321", category: "temperature" },
      { manufacturer_name: "manufacturer6", serial_number: "s064321", category: "air quality" }
    ]
  }
]

# Function to generate random data based on sensor type
def generate_random_value(category)
  case category
  when "temperature"
    rand(15..30) # Temperature in Celsius
  when "air quality"
    rand(0..100) # Air Quality Index (AQI)
  else
    rand(1..50) # Default random value
  end
end

# Function to generate a payload
def generate_payload(devices)
  selected_device = devices.sample # Select a random device
  selected_sensor = selected_device[:sensors].sample # Select a random sensor from the device

  {
    data_entry: {
      value: generate_random_value(selected_sensor[:category]).to_s,
      data_type_attributes: {
        typeName: selected_sensor[:category].capitalize,
        scale: selected_sensor[:category] == "temperature" ? "C" : "AQI"
      },
      time_of_sample_attributes: {
        date: Time.now.utc.iso8601
      },
      device_attributes: selected_device.slice(
        :manufacturer_name, :firmware_version, :software_version, :model, :serial_number, :friendly_name, :categories, :custom_id, :description
      ),
      sensor_attributes: selected_sensor
    }
  }
end

# Endpoint for posting data (replace with your actual endpoint URL)
endpoint_url = "http://127.0.0.1:3000/data_entries"

# Loop to send multiple simulated requests
100.times do |i|
  # Generate data payload
  payload = generate_payload(devices)

  # Post data payload
  response = HTTParty.post(endpoint_url,
                           body: payload.to_json,
                           headers: { 'Content-Type' => 'application/json' })

  # Output response details
  puts "Request ##{i + 1} - Status: #{response.code} - Response: #{response.body}"

  # Delay between requests
  sleep(10)
end

