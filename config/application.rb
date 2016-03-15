require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module SearchRouteWorld
  class Application < Rails::Application

    config.eager_load_paths += %W( #{config.root}/lib/rome2rio )
    config.watchable_dirs['lib'] = [:rb]
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
  end
end
