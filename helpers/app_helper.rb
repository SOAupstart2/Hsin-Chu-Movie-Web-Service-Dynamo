# Helpers for main sinatra web application
module AppHelpers
  LOCATION = { 'hsinchu' => %w(05 12) }

  def create_cinema(request)
    if request.path[6] == '1'
      cinema(params[:theater_id])
    elsif request.path[6] == '2'
      cinema_v2(params)
    end
  end

  def cinema(theater_id)
    CinemaInfo.new(theater_id)
  rescue => e
    logger.error "Fail: #{e}"
    halt 400
  end

  def cinema_v2(params)
    CinemaInfoV2.new(params[:theater_id], params[:language], params[:cinema])
  rescue => e
    logger.error "Fail: #{e}"
    halt 400
  end

  # Will be deprecated
  def film_times(location, film_name)
    LOCATION[location].map do |theater_id|
      name = cinema(theater_id).movie_table.keys[0]
      times = cinema(theater_id).film_times(film_name)
      [name, times]
    end.to_h
  rescue => e
    logger.error "Fail: #{e}"
    halt 400
  end

  # Will be deprecated
  def films_after_time(location, date_time)
    LOCATION[location].map do |theater_id|
      name = cinema(theater_id).movie_table.keys[0]
      times = cinema(theater_id).films_after_time(date_time)
      [name, times]
    end.to_h
  rescue => e
    logger.error "Fail: #{e}"
    halt 400
  end
end
