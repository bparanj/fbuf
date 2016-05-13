json.array!(@movies) do |movie|
  json.extract! movie, :id, :title, :duration, :director, :rating, :description
  json.url movie_url(movie, format: :json)
end
