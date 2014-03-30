# Application config.
require 'yaml'
require 'sinatra/base'

# Sinatra::Base.use(Rack::MethodOverride)
# Sinatra::Base.enable(:sessions)

ENV['RACK_ENV'] ||= 'development'

require_relative '../vorm'

