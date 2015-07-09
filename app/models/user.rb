# User Model is where all the system users are registered to store authentication and authorisation credentials,
# as well as associating users with services and bonuses
class User < ActiveRecord::Base
	attr_accessible :email, :name, :password, :position_id, :position, :is_admin, :has_bonus, :is_employed, :is_manager, :avail_date
	belongs_to :position
	attr_writer :position
	#attr_accessor :password
	before_create :encrypt_password
	before_update :encrypt_password

	has_many :services
	has_many :projects, :through => :services 

	validates_confirmation_of :password
	validates_presence_of :password, :on => :create
	validates_presence_of :email
	validates_uniqueness_of :email	


	def self.initials_to_email(email) 
		/\A[A-Za-z]+\z/.match(email) ? "#{email}@ciklum.com" : email
	end

	def self.authenticate(login, password) 
		user = User.find_by_email(initials_to_email(login))

		return "wrong_email" unless user
		return "wrong_password" unless user.password == Digest::SHA1.hexdigest(password)
		return "unemployed" unless user.is_employed
		user

	end


	def encrypt_password
		if password.present? and password.length != 40
				self.password = Digest::SHA1.hexdigest password 
		end
	end
end