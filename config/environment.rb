# Required for Ruby 1.9.2 and Mongodb (config/mongoid.yml)
# http://groups.google.com/group/mongoid/browse_thread/thread/9213a17a73d3c422/911f0811bf5b9d79?pli=1
require 'yaml' 
YAML::ENGINE.yamler= 'syck'

# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
Toastunes::Application.initialize!
