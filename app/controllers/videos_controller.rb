class VideosController < ApiController
  def index
    @videos = Video.all
    render json: serialized(@videos)
  end
end
