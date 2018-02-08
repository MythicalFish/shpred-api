module VideoAttachments
  extend ActiveSupport::Concern
  included do
    
    before_save :set_media_urls

    Paperclip.interpolates :sid do |attachment, style|
      attachment.instance.sid
    end

    serialize :media_urls, JSON

    # Attached file (the video itself)

    has_attached_file :file,
      :path => ":sid/:style/:basename.:extension",
      :url => ":sid/:style/:basename.:extension",
      :styles => {
        :snap => { :format => 'jpg', :geometry => "431x242#" },
        :poster => { :format => 'jpg', :geometry => "1080x720#" }
      },
      :processors => [:transcoder]

    validates_attachment_content_type :file, :content_type => /\Avideo\/.*\Z/
    validates_presence_of :file

    # Thumbnail image

    has_attached_file :thumb,
      :path => ":sid/thumb/:style/:basename.:extension",
      :url => ":sid/thumb/:style/:basename.:extension",
      :styles => {
        :small => { :format => 'jpg', :geometry => "431x242#" },
        :large => { :format => 'jpg', :geometry => "1080x720#" }
      }

    validates_attachment_content_type :thumb, :content_type => /\Aimage\/.*\Z/

    # The preview (thumbnail on-hover video)

    has_attached_file :preview,
      :path => ":sid/preview/:basename.:extension",
      :url => ":sid/preview/:basename.:extension"

    validates_attachment_content_type :preview, :content_type => /\Avideo\/.*\Z/

  end

  def thumbnail_url style = :small
    Rails.cache.fetch(ckey("thumbnail_url")) do
      if thumb.present?
        path = thumb.url(style)
      elsif file.url(:snap).present?
        path = file.url(:snap)
      end
      return storage_url("/#{path}") if path
    end
  end
  
  def poster_url
    Rails.cache.fetch(ckey("poster_url")) do
      return thumb.url(:large) if thumb
      return file.url(:poster) if file
    end
  end
  
  def preview_url
    Rails.cache.fetch(ckey("preview_url")) do
      path = preview.try(:url)
      return storage_url("/#{path}") if path
    end
  end

  def file_basename
    File.basename( file_file_name, File.extname( file_file_name ) )
  end

  def file_title
    file_file_name[/.*(?=\..+$)/].gsub("_"," ").gsub("-"," ")
  end

  def resolutions
    [1080,720,360].select { |h| height >= h }
  end

  def formats
    [:mp4, :webm]
  end

  def highest_resolution
    resolutions.first
  end

  private
  
  def set_media_urls
    self.media_urls = get_media_urls
  end

  def storage_url path = ''
    "#{ENV['SHPRED__CDN_URL']}#{path}"
  end

  def get_media_urls
    resolutions.map { |r|
      urls = formats.map { |format|
        path = "/#{sid}/#{r}p/#{file_basename}.#{format}"
        [format, path]
      }.to_h
      [r, urls]
    }.to_h
  end

  def ckey namespace
    "video#{id}/#{updated_at.to_i}/#{namespace}"
  end

end
