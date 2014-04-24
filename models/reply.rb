class Reply < ORM::Model
  # Table
  table :replies

  # Fields
  fields :message, :topic_id, :user_id

  # Validations
  validates :message, -> (reply) do
    if reply.message.nil? || reply.message.to_s.strip.empty?
      "cannot be empty"
    end
  end

  validates :topic_id, -> (reply) do
    if reply.topic_id.nil? || reply.topic_id.to_s.strip.empty?
      "is required"
    end
  end

  validates :user_id, -> (reply) do
    if reply.user_id.nil? || reply.user_id.to_s.strip.empty?
      "is required"
    end
  end

  # Relations.
  def user
    User.find(user_id)
  end
end

