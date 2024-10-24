class DataEntry < ApplicationRecord
    has_one :time_of_sample
    has_one :device
    has_one :data_type
end
