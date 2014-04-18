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

  # New.
  get '/categories/:category_id/topics/new' do
    @topic = Topic.new
    slim :'topics/new'
  end

  # Create.
  post '/categories/:category_id/topics' do
    @topic = Topic.new(params[:topic])
    if @topic.save
      redirect to(url("/topics/#{@topic.id}"))
    else
      slim :'topics/new'
    end
  end
end

