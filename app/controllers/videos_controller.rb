class VideosController < ApiController

  before_action :set_video, except: :index

  def index
    @videos = Video.exposed
    render json: @videos, each_serializer: VideoListSerializer
  end

  def show
    render json: @video
  end

  private

  def set_video
    @video = Video.friendly.find(params[:id])
  end
  
end
