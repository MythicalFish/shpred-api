class Video < ApplicationRecord
  
  include VideoSlug
  include VideoAttachments
  include VideoMeta
  include VideoEncoder

  default_scope -> { order(created_at: :desc) }
  scope :exposed, -> { where(published: true, private: false) }

end
