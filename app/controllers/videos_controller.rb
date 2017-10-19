class VideosController < ApiController
  
  def index
    render json: { status: :ok, nothing: true }
  end
end
