# Helpers for main sinatra web application
module AppHelpers
  def create_cinema(params)
    CinemaInfo.new(params[:theater_id], params[:language],
                   params[:cinema]).cinema
  rescue => e
    logger.error "Fail: #{e}"
    halt 400
  end
end
