class VideoSerializer < ActiveModel::Serializer
  attributes :id, :title, :poster_url, :media_urls, :length, :views, :slug, :storage_url, :resolutions
end
