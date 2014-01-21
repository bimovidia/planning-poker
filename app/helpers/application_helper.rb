module ApplicationHelper

  def layout_class
    user_signed_in? ? 'authenticated' : 'unauthenticated'
  end

  def publisher_client_path
    "//#{publisher_domain}/faye/client.js" unless Rails.env.test?
  end

  def publisher_environment
    ['production', 'test'].include?(Rails.env) ? Rails.env : 'development'
  end

  def publisher_domain
    Rails.configuration.publisher[:domain]
  end

  def publisher_token
    digest = OpenSSL::Digest::Digest.new('sha256')
    secret = Rails.configuration.publisher[:secret]
    data   = "/#{publisher_environment}/planning-poker/subscribe"

    OpenSSL::HMAC.hexdigest(digest, secret, data)
  end

  def broadcast(channel, &block)
    message = { channel: channel, data: capture(&block), ext: { token: publisher_token }}
    uri     = URI.parse("http://#{publisher_domain}/faye")

    Net::HTTP.post_form(uri, message: message.to_json)
  end

  def encoded_user
    Base64.strict_encode64(current_user[:username])
  end

end