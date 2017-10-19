Rails.configuration.aws = YAML.load(ERB.new(File.read("#{Rails.root}/config/aws.yml")).result)[Rails.env].symbolize_keys!
Aws::VERSION =  Gem.loaded_specs["aws-sdk"].version