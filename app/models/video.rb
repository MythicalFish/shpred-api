class Video < ApplicationRecord
  
  include VideoData
  include VideoEncoder
  include VideoMethods

  extend FriendlyId
  friendly_id :title, use: :slugged
  before_save :update_media_urls

  
  has_attached_file :file,
    :path => ":sid/:style/:basename.:extension",
    :url => ":sid/:style/:basename.:extension",
    :styles => {
      :snap => { :format => 'jpg', :geometry => "431x242#" }
    },
    :processors => [:transcoder]
  
  has_attached_file :preview,
    :path => ":sid/preview/:basename.:extension",
    :url => ":sid/preview/:basename.:extension"
  
  has_attached_file :thumb,
    :path => ":sid/thumb/:style/:basename.:extension",
    :url => ":sid/thumb/:style/:basename.:extension",
    :styles => {
      :small => { :format => 'jpg', :geometry => "431x242#" },
      :large => { :format => 'jpg', :geometry => "1080x720#" }
    }
  
  validates_attachment_content_type :file, :content_type => /\Avideo\/.*\Z/
  validates_presence_of :file
  
  validates_attachment_content_type :preview, :content_type => /\Avideo\/.*\Z/
  
  validates_attachment_content_type :thumb, :content_type => /\Aimage\/.*\Z/

  serialize :files, JSON

  Paperclip.interpolates :sid do |attachment, style|
    attachment.instance.sid
  end

  default_scope -> { order(created_at: :desc) }
  scope :exposed, -> { where(published: true, private: false) }

  def should_generate_new_friendly_id?
    title_changed?
  end

  def to_jq_video
    { "edit_url" => "admin/videos/#{video.slug}/edit" }
  end

  def update_media_urls
    self.files = media_urls
  end

end
