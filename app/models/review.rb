class Review < ActiveRecord::Base
  # id, status, user_id, movie_id
  belongs_to :user
  belongs_to :movie
end
