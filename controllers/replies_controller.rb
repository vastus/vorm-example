require 'sinatra/base'
require 'slim'

class RepliesController < Sinatra::Base
  set :views, 'views'

  # Create.
  post '/topics/:topic_id/replies/new' do
    @topic = Topic.find(params[:topic_id])
    @reply = Reply.new(params[:reply])
    if @reply.save
      redirect to(url("/topics/#{@topic.id}"))
    else
      puts params[:reply]
      puts @reply.id
      puts @reply.message
      puts @reply.user_id
      puts @reply.topic_id
      puts @reply
      slim :'topics/show'
    end
  end
end

