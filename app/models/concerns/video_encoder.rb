module VideoEncoder
  extend ActiveSupport::Concern

  PRESETS = [ 
    ['mp4', '1080p', '1351620000001-000001'],
    ['mp4', '720p', '1351620000001-000010'],
    ['mp4', '360p', '1351620000001-000040'],
    ['webm', '1080p', '1463861857156-mhzr7a'],
    ['webm', '720p', '1351620000001-100250'],
    ['webm', '360p', '1351620000001-100260']
  ]

  def self.client
    Aws::ElasticTranscoder::Client.new(
      :access_key_id => ENV['SHPRED__AWS_ACCESS_KEY_ID'],
      :secret_access_key => ENV['SHPRED__AWS_SECRET_KEY'],
      :region => ENV['SHPRED__AWS_REGION']
    )
  end

  def encode
    VideoEncoder.client.create_job encoder_request
  end

  def encoder_request
    {
      pipeline_id: '1473942538032-l4d9yv',
      input: {
        key: "#{sid}/original/#{file_file_name}"
      },
      outputs: PRESETS.map { |format, resolution, preset_id|
        {
          key:  "#{sid}/#{resolution}/#{file_basename}.#{format}",
          preset_id: preset_id
        }
      }
    }
  end

end
