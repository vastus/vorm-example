# TODO: move these to some more general place from every model
require 'sinatra/base'
require 'slim'

# require_relative '../models/category'

class TopicsController < Sinatra::Base
  set :views, 'views'
  # helpers Helpers

  # Show.
  get '/topics/:id' do
    @topic = Topic.find(params[:id])
    slim :'topics/show'
  end

  # # New.
  # get '/categories/new' do
  #   @category = Category.new
  #   slim :'categories/new'
  # end

  # # Show.
  # get '/categories/:id' do
  #   @category = Category.find(params[:id])
  #   slim :'categories/show'
  # end

  # # Create.
  # post '/categories' do
  #   @category = Category.new(params[:category])
  #   if @category.save
  #     redirect to(url('/'))
  #   else
  #     slim :'categories/new'
  #   end
  # end

  # # Edit.
  # get '/categories/:id/edit' do
  #   @category = Category.find(params[:id])
  #   slim :'categories/edit'
  # end

  # # Update.
  # put '/categories/:id' do
  #   @category = Category.find(params[:id])
  #   if @category.update(params[:category])
  #     redirect to(url('/'))
  #   else
  #     slim :'categories/edit'
  #   end
  # end
  # 
  # # Delete.
  # get '/categories/:id/delete' do
  #   Category.destroy(params[:id])
  #   redirect to(url('/'))
  # end

  # private
  # def check_ownership!
  #   if params[:id] != session[:user_id].to_s
  #     redirect to(url("/login"))
  #   end
  # end
end

