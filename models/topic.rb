require_relative '../lib/model'

class Topic < ORM::Model
  # Table name.
  table :topics

  # Fields for model.
  fields :title, :body, :category_id

  # Validations
end


