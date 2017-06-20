class User < ApplicationRecord
  # has_secure_password is a built-in rails method that provides user
  # authentication features for the model its called in
  # 1. It will automatically add a presence validator for password field
  # 2. When given a password, it will generate a salt, then it will hash the
  #    salt and password combo, then store the result into the database field
  #    (using the gem 'bcrypt')
  # 3. If you skip 'password_confirmation' field, then it won't give you
  #    a validation error for that. if you provide a 'password_confirmation',
  #    it will validate the password against it
  # 4. The user instance gets the method 'authenticate' which will allow us
  #    to verify if a user entered the correct password. It returns the user
  #    if correct, otherwise it returns 'nil'
  has_secure_password

  validates :first_name, presence: true
  validates :last_name, presence: true

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email, presence: true,
                    uniqueness: { case_sensitive: false},
                    format: VALID_EMAIL_REGEX

  before_create :generate_api_key
  before_validation :downcase_email

  has_many :questions, dependent: :nullify

  has_many :likes, dependent: :destroy
  has_many :liked_questions, through: :likes, source: :question

  has_many :votes, dependent: :destroy
  has_many :voted_questions, through: :votes, source: :question

  def full_name
    "#{first_name} #{last_name}"
  end

  private

  # You can use the .send method to call private methods
  # this should be avoided in your code, but is useful in a pinch when working
  # in the console. can also be used to dynamically call a method from a string

  # u = User.last
  # u.send(:generate_api_key)
  def generate_api_key
    loop do
      # SecureRandom.hex(32) will generate a 32 byte string of random hex
      # characters
      self.api_key = SecureRandom.hex(32)
      #
      break unless User.exists?(api_key: api_key)
    end
  end

  def downcase_email
    self.email&.downcase!
  end

end
