# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_rails2x_root_session',
  :secret      => '43f2fa69e250ef8e537694fc582dfbfcea8b45f2a7b3c719f4ecf4102047619ad5c37d59b2730fbe3059808cdf7d0da24804fbf5516dcf02535327f581507e7c'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
