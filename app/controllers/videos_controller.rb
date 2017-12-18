class VideosController < ApiController

  before_action :set_video, except: :index

  def index
    @videos = Video.exposed
    render json: @videos, each_serializer: VideoListSerializer
  end

  def show
    render json: video_response
  end

  private

  def set_video
    @video = Video.find(params[:id])
  end
  
  def requested_resolution
    params[:resolution] || @video.highest_resolution.to_s
  end

  def requested_format
    params[:format] || 'mp4'
  end

  def video_response
    {
      id: @video.id,
      title: @video.title,
      media_url: @video.media_url(requested_format, requested_resolution),
      length: @video.length,
      views: @video.views
    }
  end

end
