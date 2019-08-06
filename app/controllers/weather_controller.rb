class WeatherController < ApplicationController
  def create
    @weather = Weather.new(weather_params)
    @weather.location = Location.new(location_params)

    if @weather.save
      render json: {}, status: 201
    else
      render json: {}, status: 400
    end
  end

  def index
    @weathers = Weather.all
    status = 200

    if params[:lat] && params[:lon]
      @weathers = @weathers.by_ll(params[:lat], params[:lon])
      status = @weathers.blank? ? 404 : 200
    end

    render json: @weathers, include: :location, status: status
  end

  def temperature
    @weathers = []

    if params[:start] && params[:end]
      @weathers = Weather.between_dates(params[:start], params[:end])
    end

    @locations = @weathers.each_with_object([]) do |weather, res|
      location = weather.location
      highest = weather.temperature.max
      lowest = weather.temperature.min

      idx = res.index do |l|
        l['city'] == location.city && l['state'] == location.state &&
        l['lat'] == location.lat && l['lon'] == location.lon
      end

      if idx.present?
        res[idx]['highest'] = highest if highest > res[idx]['highest']
        res[idx]['lowest'] = lowest if lowest < res[idx]['lowest']
      else
        location_hash = location.attributes.slice('city', 'state', 'lon', 'lat').
          merge('lowest' => lowest, 'highest' => highest)
        res << location_hash
      end
    end

    @locations.each do |location|
      location['lat'] = location['lat'].to_f
      location['lon'] = location['lon'].to_f
      location['highest'] = location['highest'].to_f
      location['lowest'] = location['lowest'].to_f
    end

    @locations.sort_by!{ |l| l['city'] }

    render json: @locations
  end

  private

  def weather_params
    params.permit(:date, temperature: [])
  end

  def location_params
    params.permit(location: [:lat, :lon, :city, :state])[:location]
  end
end
