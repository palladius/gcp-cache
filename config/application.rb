require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module GcpCache
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.0

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")
    #
    ## ricc: https://stackoverflow.com/questions/17951037/how-to-require-some-lib-files-from-anywhere
    config.autoload_paths += %W[#{config.root}/lib]
    config.autoload_paths += Dir["#{config.root}/lib/**/"]
  end
end
