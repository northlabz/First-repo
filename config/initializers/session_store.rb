# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_guestbook3_session',
  :secret      => '51b1638dae112c2cb344c094b37f664c02243ecffa6c28f86a4ba1b9711c77ba3cff82701f68fa6f8d66544c8963e9753c21bb7c5f7ab29226630d532749611c'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
