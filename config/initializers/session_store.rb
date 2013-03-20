# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_community-vitals_session',
  :secret      => '40cc76f1c0824de83ba60b41804f926ccde9f0d0ee75802c50a2be6818fa8420cb3c7b384e710cc31cd9f319de190a6642e902173cd6731ab37c5d2e35d8ab77'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
