require_relative '../lib/model'

class Topic < ORM::Model
  # Table name.
  table :topics

  # Fields for model.
  fields :title, :body, :category_id

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
end

