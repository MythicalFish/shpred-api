module VideoMethods

  extend ActiveSupport::Concern

  def to_hash
    {
      title: title,
      description: description,
      views: views,
      length: length,
      files: files,
      resolutions: resolutions
    }
  end

  def thumbnail style = :small
    if thumb.present?
      thumb.url(style)
    elsif file.url(:snap).present?
      file.url(:snap)
    end
  end

end
