class VideosController < ApiController
  def index
    @videos = Video.exposed
    render json: serialized(@videos)
  end
end
