# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_webapp_session',
  :secret      => 'cdeae58cdb5328d9b2b16373ba0ae238d058698e3376d7d7decb7499e87e6a2bb4955fd480f66d5b68782f4b4506f41b1014162b234f647573e664c77f1f14ba'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
