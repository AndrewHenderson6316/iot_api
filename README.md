# IoT Data Visualization and Management System

## Overview

This is a Ruby on Rails-based web application designed to simulate, collect, store, and visualize IoT sensor data in real-time. The application uses a structured database schema to manage relationships between devices, sensors, data types, and timestamps, while providing dynamic visualizations using Chart.js.

The system includes a simulation script that generates mock IoT data and sends it to the server, making it a great prototype for validating database schema effectiveness, real-time anomaly detection, and environmental monitoring.

---

## Features

- **Real-time Data Visualization**: Displays sensor data grouped by device, with charts for each sensor showing historical trends.
- **Hierarchical Database Schema**: Manages relationships between devices, sensors, data types, and timestamps.
- **Dynamic Simulation**: Mock IoT data is generated and sent to the server to simulate real-world use cases.
- **Anomaly Detection**: Enables detection of outliers or irregularities in data for real-time insights.
- **RESTful API**: Collects, stores, and serves IoT data efficiently.

---

## Getting Started

### Prerequisites

Before running this project, ensure you have the following installed:

- **Ruby** (version 3.0 or later recommended)
- **Rails** (version 7.0 or later)
- **SQLite** (pre-installed with Rails for development)

---

### Installation Steps

1. Clone the repository:

   ```bash
   git clone https://github.com/your-repo/iot-visualization.git
   cd iot-visualization
   ```

2. Install dependencies:

   ```bash
   bundle install
   ```

3. Set up the database:

   ```bash
   bin/rails db:create db:migrate
   ```

4. Seed the database with initial data (optional):

   ```bash
   bin/rails db:seed
   ```

---

### Running the Application

1. Start the Rails server:

   ```bash
   ruby bin/rails server
   ```

   The server will be available at [http://localhost:3000](http://localhost:3000).

2. Access the real-time visualization page:

   Navigate to [http://localhost:3000/chart2](http://localhost:3000/chart2) to view the dynamic charts.

3. Start the simulation script to generate IoT data:

   ```bash
   rake simulate
   ```

   This command simulates devices and sensors generating real-time data, which is sent to the server for visualization.

---

## Key Files and Their Purposes

### `app/controllers/data_entries_controller.rb`

Handles CRUD operations for `DataEntry` objects. Includes methods for:

- `index`: Fetches all data entries and returns them as JSON.
- `chart2`: Renders the `chart2` view for real-time data visualization at `/chart2`.

### `app/db/schema.rb`

Defines the database schema, including tables for:

- `data_entries`: Stores IoT sensor data, including timestamps and associated device and sensor IDs.
- `data_types`: Holds information about the type and scale of data (e.g., temperature in Celsius).
- `devices`: Stores metadata about IoT devices (e.g., manufacturer, model, and friendly name).
- `sensors`: Details individual sensors linked to devices.
- `time_of_samples`: Captures timestamps of sensor readings.

### `app/views/data_entries/chart2.html.erb`

The view for rendering real-time visualizations of IoT data. Displays grouped charts for each device and its sensors. Accessible at [http://localhost:3000/chart2](http://localhost:3000/chart2).

### `lib/tasks/simulate.rake`

Defines the simulation task (`rake simulate`) that generates mock IoT data. Simulates data for devices and sensors and sends it to the Rails server via HTTP requests.

---

## Dependencies

- **Ruby on Rails**: The core framework for the application.
- **SQLite**: Lightweight database used for storing IoT data.
- **Chart.js**: Library for rendering real-time data visualizations.
- **HTTParty**: Gem for sending HTTP requests, used in the simulation script.
- **Date-Fns Adapter**: For time formatting in Chart.js.

Install all dependencies with:

```bash
bundle install
```

---

## Usage

### Data Visualization

The application groups sensors by device and visualizes their data in real-time using charts. Each sensor has its own chart, and devices are displayed in separate sections.

### Simulated Data

The simulation generates random data for temperature (0–30°C) and air quality (0–100 AQI), representing IoT device readings. It ensures realistic data that can demonstrate how the system handles and visualizes real-world IoT scenarios.

---

## Extending the Prototype

This project serves as a prototype and can be extended in the following ways:

- **Machine Learning Integration**: Add predictive models for anomaly detection.
- **Multi-Device Support**: Expand the schema and API to handle millions of devices and sensors.
- **Real-Time Updates**: Use WebSockets or server-sent events for live data streaming.
- **Geographical Data**: Incorporate location metadata for devices.

---

## License

This project is licensed under the MIT License. See the `LICENSE` file for details.
