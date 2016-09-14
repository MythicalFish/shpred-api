module VideoEncoder

  extend ActiveSupport::Concern

  def self.client
    Aws::ElasticTranscoder::Client.new(
      :access_key_id => ENV['AWS_ACCESS_KEY_ID'],
      :secret_access_key => ENV['AWS_SECRET_KEY'],
      :region => ENV['AWS_REGION']
    )
  end

  def encode
    VideoEncoder.client.create_job encoder_request
  end

  def encoder_request

    request = {
      pipeline_id: '1463345701251-a3vqge',
      input: {
        key: input_video_path
      },
      outputs: []
    }

    resolutions.each do |r|
      r[:presets].each do |format,preset_id|

        request[:outputs] << {
          key:  "#{sid}/#{r[:label]}/#{file_basename}.#{format}",
          preset_id: preset_id
        }

      end
    end

    request

  end

  def input_video_path
    "#{sid}/original/#{file_file_name}"
  end

end
