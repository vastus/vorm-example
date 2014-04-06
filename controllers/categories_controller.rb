require 'sinatra/base'
require 'slim'

require_relative '../models/category'

class CategoriesController < Sinatra::Base
  set :views, 'views'

  # ['/users/:id/edit'].each do |path|
  #   before path do
  #     check_ownership!
  #   end
  # end

  # New.
  get '/' do
    @categories = Category.all
    slim :'categories/index'
  end

  # Show.
  get '/users/:id' do
    @user = User.find(params[:id])
    slim :'users/show'
  end

  # Create.
  post '/users' do
    @user = User.new(params[:user])
    if @user.save
      redirect to(url('/'))
    else
      slim :'users/new'
    end
  end

  # Edit.
  get '/users/:id/edit' do
    @user = User.find(params[:id])
    slim :'users/edit'
  end

  # Update.
  post '/users/:id' do
    "To be implemented."
    # @user = User.find(params[:id])
    # if @user.update(params[:user])
    #   redirect to(url("/users/#{@user.id}"))
    # else
    #   slim :'users/edit'
    # end
  end

  private
  def check_ownership!
    if params[:id] != session[:user_id].to_s
      redirect to(url("/login"))
    end
  end
end
