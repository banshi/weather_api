class Location < ActiveRecord::Base
  belongs_to :weather

  def as_json(options = {})
    hash = super(except: [:id, :weather_id])
    hash['lat'] = hash['lat'].to_f
    hash['lon'] = hash['lon'].to_f
    hash
  end
end
