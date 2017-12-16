Rails.application.config.paperclip_defaults = {
  :storage => :fog,
  :fog_credentials =>  {
    provider: 'AWS',
    aws_access_key_id: ENV['SHPRED__AWS_ACCESS_KEY_ID'],
    aws_secret_access_key: ENV['SHPRED__AWS_SECRET_KEY'],
    region: ENV['SHPRED__AWS_REGION']
  },
  :fog_directory => ENV['SHPRED__S3_BUCKET'],
  :fog_host => ENV['SHPRED__CDN_URL']
}