class VideoSerializer < ActiveModel::Serializer
  attributes :id, :title, :length, :views, :resolutions, :formats
end
