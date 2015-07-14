class AddHatesToMovies < ActiveRecord::Migration
  def change
    add_column :movies, :hates, :integer
  end
end
