require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module PickPal
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.1

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    config.base_url = 'http://eu.battle.net/heroes/en/heroes/'
    config.hero_base_url = 'http://eu.battle.net/heroes/en/heroes/%s/'
    config.local_file = File.dirname(__dir__) + '/data/heroes.json'
    config.local_hero_folder = File.dirname(__dir__) + '/data/heroes'
    config.local_detail_file = File.dirname(__dir__) + '/data/heroes_detail.json'
    config.hero_local_file = File.dirname(__dir__) + '/data/heroes/%s.json'
    config.image_urls = {
        'bust' => 'http://media.blizzard.com/heroes/%s/bust.jpg',
        'trait' => 'http://media.blizzard.com/heroes/%s/abilities/icons/%s.png'
    }

    config.image_path = '/images/'
    config.hero_image_pre = {
        'greymane' => 'greymane/',
        'valeera' => 'standard/',
        'varian' => 'warrior/',
        'chogall' => 'cho/',
    }
  end
end
