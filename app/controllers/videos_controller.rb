class VideosController < ApiController

  before_action :set_video, except: :index

  def index
    @videos = Rails.cache.fetch(ckey) { Video.exposed }
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

  def ckey 
    ts = Video.order(:updated_at).first.updated_at.to_i
    "videos/#{ts}"
  end
  
end
