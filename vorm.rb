require 'sinatra/base'

#require './config'
require './controllers/users_controller'
require './controllers/sessions_controller'
require './controllers/categories_controller'

Slim::Engine.set_default_options(:pretty => true, :sort_attrs => false)

class Vorm < Sinatra::Base
  enable :sessions
  use UsersController
  use SessionsController
  use CategoriesController
end

