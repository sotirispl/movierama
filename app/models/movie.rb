class Movie < ActiveRecord::Base
  # id, title, description, image, user_id
  belongs_to :user
  has_many :reviews
  validates :title, :description, :presence => true

  has_attached_file :image, :styles => { :medium => "500x500>", :thumb => "250x250>" }, :default_url => "/system/movies/images/:style/missing.png"
  validates_attachment_content_type :image, :content_type => /\Aimage\/.*\Z/
end
