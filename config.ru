require 'rubygems'
require 'haml'
require 'cgi'
require 'yaml'
require 'vendor/sinatra/lib/sinatra'

opts = YAML.load_file(File.join(File.dirname(__FILE__), "config.yml"))
set :views,       opts['views']
set :music,       opts['music']
set :environment, opts['environment']
set :haml,        {:format => :html5 } # default Haml format is :xhtml
disable :run if opts['environment'] == :development

require 'toastunes.rb'
run Sinatra::Application
