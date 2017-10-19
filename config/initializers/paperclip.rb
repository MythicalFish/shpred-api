Rails.application.config.paperclip_defaults = {
  :storage => :fog,
  :fog_credentials =>  {
    provider: 'AWS',
    aws_access_key_id: ENV['AWS_ACCESS_KEY_ID'],
    aws_secret_access_key: ENV['AWS_SECRET_KEY'],
    region: ENV['AWS_REGION']
  },
  :fog_directory => ENV['S3_BUCKET'],
  :fog_host => 'http://content.shp.red'
}