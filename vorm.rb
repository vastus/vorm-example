require 'sinatra/base'

class Vorm < Sinatra::Base
  get '/' do
    "Hi there."
  end
end

