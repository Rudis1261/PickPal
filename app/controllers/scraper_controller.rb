require 'httparty'

class ScraperController < ApplicationController

  def index
    render :json => { 'hello' => 'casta' }
  end

  def all
    resp = HTTParty.get(Rails.configuration.base_url)
    if !resp || resp.code != 200
      return render :json => ApplicationHelper.error("Scraping failed, RESP Code: #{resp.code}")
    end

    data = resp.body.scan(/window\.heroes.+= (.+);/)
    if !data || data.nil?
      return render :json => ApplicationHelper.error('Scraping failed, Unable to find window.heroes object we need')
    end

    heroes = JSON.pretty_generate(JSON.parse(data[0].first))
    if !heroes || heroes.nil?
      return render :json => ApplicationHelper.error('Scraping failed, Unable to parse window.heroes object')
    end

    #StorageHelper.save_to_disk(heroes)
    #ScraperHelper.parse_hero_details_and_save_to_disk
    render :json => ScraperHelper.parse_json_data(heroes)
  end

  def one
    name_pattern = /^[a-zA-Z\-]+$/
    if !params[:name] || params[:name].scan(name_pattern) == [] || params[:name].scan(name_pattern).first != params[:name]
      return render :json => ApplicationHelper.error('Invalid name provided')
    end

    name = params[:name]
    resp = HTTParty.get(Rails.configuration.hero_base_url % name)
    if !resp || resp.code != 200
      return render :json => ApplicationHelper.error("Scraping hero '#{name}' failed, RESP Code: #{resp.code}")
    end

    data = resp.body.scan(/window\.hero.+= (.+);/)
    if !data || data.nil?
      return render :json => ApplicationHelper.error("Scraping hero '#{name}' failed, Unable to find window.hero object we need")
    end

    hero = JSON.parse(data[0].first)
    if !hero || hero.nil?
      return render :json => ApplicationHelper.error("Scraping hero '#{name}' failed, Unable to parse window.hero object")
    end

    render :json => JSON.pretty_generate(ScraperHelper.parse_hero_json_data(hero))
  end
end
