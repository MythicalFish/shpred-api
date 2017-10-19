module VideoData

  extend ActiveSupport::Concern

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

  def meta

    meta = {
      :length => '0:00',
      :dimensions => '0x0',
      :width => 0,
      :height => 0
    }

    if file_meta
      meta[:length] =     file_meta[/[0-9]+:[0-9]+:[0-9]+/]
      meta[:length] =     meta[:length][2,meta[:length].length] if meta[:length][0] == '0'
      meta[:dimensions] = file_meta[/[0-9]+x[0-9]+/]
      meta[:width] =      meta[:dimensions][/^[^x]+/].to_i
      meta[:height] =     meta[:dimensions][/x[0-9]+/][1,meta[:dimensions].length].to_i
    end

    meta

  end

  def storage_url
    "http://content.shp.red/#{sid}"
  end

  def file_basename
    File.basename( file_file_name, File.extname( file_file_name ) )
  end

  def thumb_basename
    File.basename( thumb_file_name, File.extname( thumb_file_name ) )
  end

  def preview_basename
    File.basename( preview_file_name, File.extname( preview_file_name ) )
  end

  def resolutions

    r = []

    RESOLUTIONS.each do |resolution|
      if meta[:height] >= resolution[:height]
        r << resolution
      end
    end

    r

  end

  def file_title
    file_file_name[/.*(?=\..+$)/].gsub("_"," ").gsub("-"," ")
  end

  def media_urls

    urls = {
      :snap =>      file.url(:snap),
      :video => {
        :mp4 =>       {},
        :webm =>      {}
      }
    }

    resolutions.each do |r|
      r[:presets].each do |format,preset_id|
        urls[:video][format][r[:label]] = "#{storage_url}/#{r[:label]}/#{file_basename}.#{format}"
      end
    end

    if thumb.present?
      urls[:thumb] = {
        :small => thumb.url(:small),
        :large => thumb.url(:large)
      }
    end

    if preview.present?
      urls[:preview] = preview.url
    end

    urls

  end

  def populate_meta
    update_attributes({
      :length =>      meta[:length],
      :dimensions =>  meta[:dimensions],
      :width =>       meta[:width],
      :height =>      meta[:height],
      :files =>       media_urls
    })
  end

end
