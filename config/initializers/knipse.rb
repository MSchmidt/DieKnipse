knipse_config_file = File.join(Rails.root,'config','knipse.yml')
raise "#{knipse_config_file} is missing!" unless File.exists? knipse_config_file
KNIPSE_CONFIG = YAML.load_file(knipse_config_file)[Rails.env].symbolize_keys
