require 'sinatra/base'
require 'slim'

# make sure relative to config.ru's path
require './models/user'

class SessionsController < Sinatra::Base
  set :views, 'views'

  # New.
  ['/login', '/sessions/new/?'].each do |path|
    get path do
      slim :'sessions/new'
    end
  end

  # Create.
  ['/login', '/sessions'].each do |path|
    post path do
      user = User.find_by(:username, params[:username])
      if user && user.authenticate(params[:password])
        session[:user_id] = user.id
        redirect to(url("/users/#{user.id}"))
      else
        @errors = "Username or password mismatch"
        slim :'sessions/new'
      end
    end
  end

  # Delete.
  ['/login', '/sessions'].each do |path|
    delete path do
      session[:user_id] = nil
      redirect to(url("/"))
    end
  end
end

