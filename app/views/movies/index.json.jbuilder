json.array!(@movies) do |movie|
  json.extract! movie, :id, :title, :description, :user_id
  json.url movie_url(movie, format: :json)
end
