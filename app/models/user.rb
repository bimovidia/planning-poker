class User
  include Mongoid::Document
  include Mongoid::Timestamps

  field :username, type: String
  field :password, type: String
  field :salt, type: String
  field :token, type: String

  # user registration logic specific callback
  before_save { |record| record.encrypt_password }

  class << self
    # Authenticates a user by their username and
    # unencrypted password. Returns the user or nil.
    def authenticate(params)
      return if params[:password].blank?

      user = find_by(
        username: params[:username]
      ) # need to get the salt

      user && user.authenticated?(params[:password]) ? user : create(params)
    end

    def create(params)
      # Set Pivotal Tracker token
      token = PivotalTracker::Client.token(
        params[:username],
        params[:password]
      )

      salt = salted(
        params[:username]
      )

      user = new(
        username: params[:username],
        password: params[:password],
        token:    token
      )

      user.save

      user
    end

    # Creates the salt
    def salted(username)
      Digest::SHA1.hexdigest("--#{Time.now.to_s}--#{username}--")
    end

    # Encrypts some data with the salt.
    def encrypt(password, salt)
      Digest::SHA1.hexdigest("--#{salt}--#{password}--")
    end
  end

  # Checks passwords against crypted password
  def authenticated?(password)
    self.password == encrypt(password)
  end

  # Encrypts the password with the user salt
  def encrypt(password)
    self.class.encrypt(password, salt)
  end

  protected
  # before filter
  def encrypt_password
    return if password.blank?

    self.salt     = self.class.salted(username) if new_record?
    self.password = encrypt(password)
  end

end