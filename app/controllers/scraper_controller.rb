class ScraperController < ApplicationController
  def initialize
  end

  def index
    raise Rails.configuration.local_file
    # Rails.configuration.base_url
    # config.base_url = 'http://eu.battle.net/heroes/en/heroes/'
    # config.hero_base_url = 'http://eu.battle.net/heroes/en/heroes/%s/'
    # config.local_file = File.dirname(__FILE__) + '/data/heroes.json'
    # config.local_hero_folder = File.dirname(__FILE__) + '/data/heroes'
    # config.local_detail_file = File.dirname(__FILE__) + '/data/heroes_detail.json'
    # config.hero_local_file = File.dirname(__FILE__) + '/data/heroes/%s.json'
    # config.image_urls = {
    #     'bust' => 'http://media.blizzard.com/heroes/%s/bust.jpg',
    #     'trait' => 'http://media.blizzard.com/heroes/%s/abilities/icons/%s.png'
    # }
    #
    # config.image_path = '/images/'
    # config.hero_image_pre = {
    #     'greymane' => 'greymane/',
    #     'valeera' => 'standard/',
    #     'varian' => 'warrior/',
    #     'chogall' => 'cho/',
    # }
    render :json => { 'hello' => 'casta' }
  end
end
