json.extract! ingredient, :id, :parent_id, :name, :is_basic, :is_public, :serving_size, :calories, :protein_grams, :created_at, :updated_at
json.url ingredient_url(ingredient, format: :json)
