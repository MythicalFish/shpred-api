module VideoMeta

  extend ActiveSupport::Concern

  included do
    before_create :set_meta
  end

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

  def set_meta
    self.assign_attributes({
      :title =>       file_file_title,
      :sid =>         SecureRandom.hex,
      :length =>      meta[:length],
      :dimensions =>  meta[:dimensions],
      :width =>       meta[:width],
      :height =>      meta[:height]
    })
  end

end
