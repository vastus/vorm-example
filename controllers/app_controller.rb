class AppController < Sinatra::Base
  set :views, 'views'
  helpers Helpers

  def authenticate!
    halt 401, "You need to be logged in to do that!" unless current_user
  end

  def authorize!
    halt 401, "Unauthorized access!" unless admin?
  end
end

