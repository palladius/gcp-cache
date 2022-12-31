# Be sure to restart your server when you modify this file.

# Configure parameters to be filtered from the log file. Use this to limit dissemination of
# sensitive information. See the ActiveSupport::ParameterFilter documentation for supported
# notations and behaviors.
Rails.application.config.filter_parameters += [
  :passw, :secret, :token,
  # removing as it filters the GCP key... which i dont want. Maybe i should just rename it?
  #:_key, 
  :crypt, :salt, :certificate, :otp, :ssn
]
