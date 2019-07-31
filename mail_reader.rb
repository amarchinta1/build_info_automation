require 'pry'
require 'yaml'

config_file = File.new("./config/imap_config.yaml")
binding.pry
config = YAML.load_file(config_file.read)
puts config
binding.pry      		
