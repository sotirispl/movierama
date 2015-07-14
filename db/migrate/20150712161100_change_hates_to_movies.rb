class ChangeHatesToMovies < ActiveRecord::Migration
  def change
  	change_column :movies, :likes, :integer, :default => 0
  	change_column :movies, :hates, :integer, :default => 0
  end
end
