require 'sinatra/base'

#require './config'
require './controllers/users_controller'
require './controllers/sessions_controller'

class Vorm < Sinatra::Base
  enable :sessions
  use UsersController
  use SessionsController
end

