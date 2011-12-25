settings = YAML.load_file(File.join(::Rails.root, 'config', 'toastunes.yml'))

config = Toastunes::Application.config

config.itunes_library =           settings['itunes_library']
config.itunes_base =              settings['itunes_base']
config.local_base =               settings['local_base']
config.amazon_access_key_id =     settings['amazon_access_key_id']
config.amazon_secret_access_key = settings['amazon_secret_access_key']
config.amazon_associate_tag =     settings['amazon_associate_tag']

# uncomment this while hacking ruby-mp3info
# $: << "/Users/toast/code/ruby-mp3info/lib/"
# require 'mp3info'
