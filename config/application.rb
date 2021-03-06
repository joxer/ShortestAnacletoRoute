require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module SearchRouteWorld
  class Application < Rails::Application
    config.eager_load_paths += %W( #{config.root}/app/rome2rio/ )
    config.active_record.time_zone_aware_types = [:datetime]

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
  end
end
