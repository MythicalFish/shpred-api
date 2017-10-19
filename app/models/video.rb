class Video < ApplicationRecord

  before_save :update_media_urls

  RESOLUTIONS = [
    {
      height:   1080,
      label:    '1080p',
      presets: {
        mp4: '1351620000001-000001',
        webm: '1463861857156-mhzr7a'
      }
    },{
      height:   720,
      label:    '720p',
      presets: {
        mp4: '1351620000001-000010',
        webm: '1351620000001-100250'
      }
    },{
      height:   360,
      label:    '360p',
      presets: {
        mp4: '1351620000001-000040',
        webm: '1351620000001-100260'
      }
    }
  ]

  include VideoData
  include VideoEncoder
  include VideoMethods

  extend FriendlyId
  friendly_id :title, use: :slugged

  serialize :files, JSON

  acts_as_taggable

  self.per_page = 20

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

  Paperclip.interpolates :sid do |attachment, style|
    attachment.instance.sid
  end

  scope :published, -> { where(published: true) }
  scope :latest, -> { order(created_at: :desc) }

  def should_generate_new_friendly_id?
    title_changed?
  end

  def to_jq_video
    { "edit_url" => "admin/videos/#{video.slug}/edit" }
  end

  def self.categories
    self.tag_counts.sort { |x, y| x.name <=> y.name }
  end

  def update_media_urls
    self.files = media_urls
  end

end
