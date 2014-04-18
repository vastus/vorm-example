class Topic < ORM::Model
  # Table name.
  table :topics

  # Fields for model.
  fields :title, :body, :category_id, :user_id

  # Validations
  validates :title, -> (topic) do
    if topic.title.nil? || topic.title.strip.empty?
      "cannot be empty"
    end
  end

  validates :body, -> (topic) do
    if topic.body.nil? || topic.body.strip.empty?
      "cannot be empty"
    end
  end

  validates :category_id, -> (topic) do
    if topic.category_id.nil? || topic.title.to_s.strip.empty?
      "cannot be empty"
    end
  end

  validates :user_id, -> (topic) do
    if topic.user_id.nil? || topic.user_id.to_s.strip.empty?
      "cannot be empty"
    end
  end
end

