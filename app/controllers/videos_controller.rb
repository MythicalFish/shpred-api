class VideosController < ApiController
  def index
    @videos = Video.exposed
    render json: @videos, each_serializer: VideoListSerializer
  end
end
