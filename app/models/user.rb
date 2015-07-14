class User < ActiveRecord::Base
	# id, name, email, password (salt, encrypted)
	has_many :movies
	has_many :reviews

	validates :name, presence: true

	# Include default devise modules. Others available are:
	# :confirmable, :lockable, :timeoutable and :omniauthable
	devise :database_authenticatable, :registerable,
	     :recoverable, :rememberable, :trackable, :validatable
end
