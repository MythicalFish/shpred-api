module Api   
  class VideosController < ActionController::API
    def index
      render json: { status: :ok, nothing: true }
    end
  end
end