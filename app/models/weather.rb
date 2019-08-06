class Weather < ActiveRecord::Base
  serialize :temperature, Array
  has_one :location, dependent: :destroy

  validate :validate_uniqueness_date_within_location

  scope :between_dates, ->(start_date, end_date){
    where("date BETWEEN ? AND ?", start_date, end_date)
  }

  scope :by_ll, ->(lat, lon){
    joins(:location).where(locations: {lat: lat, lon: lon})
  }

  def validate_uniqueness_date_within_location
    existing_weathers = Weather.where(date: date)
    existing_location = existing_weathers.joins(:location).find_by(
      locations: {
        lat: location.lat,
        lon: location.lon,
        city: location.city,
        state: location.state
      }
    )

    if existing_location
      errors.add(:date, 'not unique in scope of location')
    end
  end

  def as_json(options = {})
    hash = super()
    hash['temperature'] = hash['temperature'].map(&:to_f)
    hash['location'] = location.as_json
    hash
  end
end
