# require 'rubygems'
# ENV['RACK_ENV'] = 'test'                    # force the environment to 'test'
# 
# require 'sinatra/base'
# require 'rspec'
# require 'rack/test'
# 
# #require File.join(File.dirname(__FILE__), '../config/application')
# 
# Sinatra::Base.set :environment, :test
# Sinatra::Base.set :run, false
# Sinatra::Base.set :raise_errors, true
# Sinatra::Base.set :logging, false
# 
# RSpec.configure do |conf|
#   conf.include Rack::Test::Methods
# end
# 
# def app
#   @app ||= Sinatra::Application
# end

ENV['RACK_ENV'] ||= 'test'
require File.join(File.dirname(__FILE__), '../config/application')
Sinatra::Base.set(:environment, :test)
Sinatra::Base.set(:run, false)

# See http://rubydoc.info/gems/rspec-core/RSpec/Core/Configuration
RSpec.configure do |config|
  config.treat_symbols_as_metadata_keys_with_true_values = true
  config.run_all_when_everything_filtered = true
  config.filter_run :focus

  # Run specs in random order to surface order dependencies. If you find an
  # order dependency and want to debug it, you can fix the order by providing
  # the seed, which is printed after each run.
  #     --seed 1234
  config.order = 'random'
end
