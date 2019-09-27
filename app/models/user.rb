class User < ApplicationRecord
  # Virtual attribute for authentication via username or email
  attr_accessor :login

  PASSWORD_COMPLEXITY = /\A(?=.*?[A-Z])(?=.*?[a-z])((?=.*?[0-9])|(?=.*?[#?!@$%^&*-])).{8,}/x

  # Devise configuration
  devise :database_authenticatable, :registerable

  # Associations
  has_many :shifts, dependent: :destroy
  has_many :clock_events, through: :shifts

  # Validations
  validates :email, presence: true, uniqueness: true, length: { maximum: 255 }
  validates :name, presence: true, length: { minimum: 2, maximum: 255 }
  validates :username, presence: :true
	validates :password,
    format: { with: PASSWORD_COMPLEXITY, message: 'needs to be complex!' },
    on: :create

  # Overwriting devise's method
  def self.find_for_database_authentication warden_conditions
    conditions = warden_conditions.dup
    login = conditions.delete(:login)
    where(conditions).where(["lower(username) = :value OR lower(email) = :value", {value: login.strip.downcase}]).first
  end

end
