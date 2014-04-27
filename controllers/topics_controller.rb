class TopicsController < AppController
  # Show.
  get '/topics/:id' do
    @topic = Topic.find(params[:id])
    mark_as_read!(@topic)
    slim :'topics/show'
  end

  # New.
  get '/categories/:category_id/topics/new' do
    authenticate!
    @topic = Topic.new
    slim :'topics/new'
  end

  # Create.
  post '/categories/:category_id/topics' do
    authenticate!
    @topic = Topic.new(params[:topic])
    if @topic.save
      redirect to(url("/topics/#{@topic.id}"))
    else
      slim :'topics/new'
    end
  end

  # Unread.
  get '/unread' do
    authenticate!
    @topics = current_user.unread
    slim :'topics/index'
  end

  private 
  def mark_as_read!(topic)
    if current_user
      ReadTopics.create(user_id: current_user.id, topic_id: topic.id)
    end
  end
end

