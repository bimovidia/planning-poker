class User < ActiveRecord::Base

  # user registration logic specific callback
  before_save do
    return if password.blank?

    self.salt     = self.class.salted(username) if new_record?
    self.password = encrypt(password)
  end

  class << self

    # Authenticates a user by their username and
    # unencrypted password. Returns the user or nil.
    def authenticate(params)
      return if params[:password].blank?

      user = User.where(username: params[:username])[0] # need to get the salt
      user && user.authenticated?(params[:password]) ? user : create(params)
    end

    def create(params)
      begin
        api_response = RestClient::Request.execute(method: :get, url: "https://www.pivotaltracker.com/services/v5/me", user: params[:username], password: params[:password])
        token = JSON.parse(api_response)["api_token"]
      rescue Exception => err
        puts err.response
        return
      end


      salt = salted(
        params[:username]
      )

      user = User.new(
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

end