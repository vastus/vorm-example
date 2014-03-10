require 'sinatra/base'

#require './config'
require './controllers/users_controller'

class Vorm < Sinatra::Base
  enable :sessions
  use UsersController
end

