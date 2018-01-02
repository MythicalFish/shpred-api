class VideosController < ApiController

  before_action :set_video, except: :index

  def index
    @videos = Video.exposed
    render json: @videos, each_serializer: VideoListSerializer
  end

  def show
    increment_viewcount
    render json: @video
  end

  private

  def set_video
    @video = Video.friendly.find(params[:id])
  end

  def increment_viewcount
    @video.views += 1
    @video.save!
  end
  
end
