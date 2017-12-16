class VideoListSerializer < ActiveModel::Serializer
  attributes :id, :title, :thumbnail_url, :preview_url
end
