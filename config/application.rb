require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Cc
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    config.time_zone = Settings.General.Timezone

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de

    # Do not swallow errors in after_commit/after_rollback callbacks.
    config.active_record.raise_in_transactional_callbacks = true

    config.generators do |g|
      g.test_framework :rspec,
        :fixtures => true, #specifies to generate a fixture for each model
        :view_specs => false, #skip generating view specs
        :helper_specs => false, #skips generating specs for the helper files (TODO at a later point, add those)
        :routing_specs => false, #TODO: maybe test routing later as well
        :controller_specs => true,
        :request_specs => true
      g.fixture_replacement :factory_girl, :dir => "spec/factories"

      g.orm             :active_record
      g.template_engine :erb

    end

    WillPaginate.per_page = Settings.Pagination.NoOfEntriesPerPage
  end
end
