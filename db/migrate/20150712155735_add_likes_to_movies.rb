class AddLikesToMovies < ActiveRecord::Migration
  def change
    add_column :movies, :likes, :integer
  end
end
