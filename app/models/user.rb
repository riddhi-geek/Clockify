class User < ApplicationRecord
  PASSWORD_COMPLEXITY = /\A(?=.*?[A-Z])(?=.*?[a-z])((?=.*?[0-9])|(?=.*?[#?!@$%^&*-])).{8,}/x
  PASSWORD_MIN_LENGTH = 8

  # Devise configuration
  devise :database_authenticatable, :registerable

  # Associations
  has_many :shifts, dependent: :destroy
  has_many :clock_events, through: :shifts

  # validations
  validates :email, presence: true, uniqueness: true, length: { maximum: 255 }
  validates :name, presence: true, length: { minimum: 2, maximum: 255 }
  validates :employee_code, uniqueness: true
	validates :password,
    length: { minimum: PASSWORD_MIN_LENGTH },
    format: { with: PASSWORD_COMPLEXITY, message: 'needs to be complex!' },
    on: :create
  validates :password,
    length: { minimum: PASSWORD_MIN_LENGTH },
    confirmation: true,
    format: { with: PASSWORD_COMPLEXITY, message: 'needs to be complex!' },
    on: :update, unless: lambda{ |user| user.password.blank? }

end
