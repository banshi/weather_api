class EraseController < ApplicationController
  def delete
    @weathers = Weather.all

    if params[:start] && params[:end]
      @weathers = @weathers.between_dates(params[:start], params[:end])
    end

    if params[:lat] && params[:lon]
      @weathers = @weathers.by_ll(params[:lat], params[:lon])
    end

    @weathers.destroy_all
    head :ok
  end
end