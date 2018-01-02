class VideoListSerializer < ActiveModel::Serializer
  attributes :id, :title, :thumbnail_url, :preview_url, :length, :views, :slug
end
