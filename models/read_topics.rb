require_relative './user'
require_relative './topic'

class ReadTopics < ORM::Model
  # Table name.
  table :readtopics

  # Fields.
  fields :user_id, :topic_id

  # Validations.
  validates :user_id, -> (rt) do
    if rt.user_id.nil? || rt.user_id.to_s.strip.empty?
      "cannot be empty"
    end
  end

  validates :topic_id, -> (rt) do
    if rt.topic_id.nil? || rt.topic_id.to_s.strip.empty?
      "cannot be empty"
    end
  end

  # belongs_to :user
  def user
    User.find(user_id)
  end

  # belongs_to :topic
  def topic
    Topic.find(topic_id)
  end
end

