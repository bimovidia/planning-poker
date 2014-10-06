# Be sure to restart your server when you modify this file.

# Your secret key is used for verifying the integrity of signed cookies.
# If you change this key, all old signed cookies will become invalid!

# Make sure the secret is at least 30 characters and all random,
# no regular words or you'll be exposed to dictionary attacks.
# You can use `rake secret` to generate a secure secret key.

# Make sure your secret_key_base is kept private
# if you're sharing your code publicly.
if Rails.env.production?
  PlanningPokerRails::Application.config.secret_key_base = ENV['SECRET_TOKEN']
else
  PlanningPokerRails::Application.config.secret_key_base = 'af4ae4865e62ae7bccbdde6e4479d7df37ea98886846898d4a7af13cd5fe1cc671aa5e9f8d52024168e6bab53f7166901f8a70e754b6224ebf917671e4e9be65'
end
