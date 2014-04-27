class RepliesController < AppController
  # Create.
  post '/topics/:topic_id/replies/new' do
    authenticate!
    @topic = Topic.find(params[:topic_id])
    @reply = Reply.new(params[:reply])
    if @reply.save
      redirect to(url("/topics/#{@topic.id}"))
    else
      slim :'topics/show'
    end
  end
end

