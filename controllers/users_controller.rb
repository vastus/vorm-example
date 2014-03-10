require 'sinatra/base'
require 'slim'

class UsersController < Sinatra::Base
  set :views, 'views'

  # Show.
  get '/users/:id' do
    slim :'users/show'
  end

  # New.
  ['/register', '/users/new/?'].each do |path|
    get path do
      slim :'users/new'
    end
  end
end

