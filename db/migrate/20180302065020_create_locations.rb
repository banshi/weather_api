class CreateLocations < ActiveRecord::Migration
  def change
    create_table :locations do |t|
      t.decimal "lat", precision: 10, scale: 5, null: false
      t.decimal "lon", precision: 10, scale: 5, null: false
      t.integer "weather_id"
      t.string "state"
      t.string "city"
      t.index ["weather_id"], name: "index_locations_on_weather_id"
      t.index ["lat", "lon"], name: "index_locations_on_lat_and_lon"
    end
  end
end
