require 'sinatra/base'

#require './config'
require './controllers/users_controller'

class Vorm < Sinatra::Base
  use UsersController
  set :views, 'views'
end

