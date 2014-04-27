class SessionsController < AppController
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
        url = params[:ref].empty? ? url("/users/#{user.id}") : params[:ref]
        redirect to(url)
      else
        @errors = "Username or password mismatch"
        slim :'sessions/new'
      end
    end
  end

  # Destroy (DELETE).
  ['/logout', '/sessions'].each do |path|
    delete path do
      session[:user_id] = nil
      redirect to(url("/"))
    end
  end

  # Destroy (GET).
  get '/logout' do
    session[:user_id] = nil
    redirect to(url("/"))
  end
end

