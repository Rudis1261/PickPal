require 'httparty'
require 'thread'
require 'thwait'

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

    heroes = JSON.parse(data[0].first)
    if !heroes || heroes.nil?
      return render :json => ApplicationHelper.error('Scraping failed, Unable to parse window.heroes object')
    end

    result = []
    heroes.each do |hero|
      result << scrape_hero(hero['slug'])
    end

    render :json => result.to_json
  end

  def one
    name_pattern = /^[a-zA-Z\-]+$/
    if !params[:name] || params[:name].scan(name_pattern) == [] || params[:name].scan(name_pattern).first != params[:name]
      return render :json => ApplicationHelper.error('Invalid name provided')
    end

    hero = scrape_hero params[:name]

    if hero.nil?
      ApplicationHelper.error('Unable to get hero json')
    end

    render :json => hero.to_json
  end

  private

  def scrape_hero(name)
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

    hero = ScraperHelper.parse_hero_json_data(hero)
    save_hero_to_disk(hero)
    save_hero(hero)
  end

  def save_hero(parsed_hero_data)
    hero_fields = ['name', 'title', 'slug', 'description', 'live', 'type_of_hero', 'franchise', 'difficulty', 'poster_image', 'thumb']
    hero = Hero.find_by_slug(parsed_hero_data['slug'])
    role = Role.find_by_slug(parsed_hero_data['role']['slug'])

    hero = Hero.new if (hero.nil?)
    role = Role.new if (role.nil?)

    # Default fields
    hero_fields.each do |field|
      hero[field] = parsed_hero_data[field]
    end

    # Roles
    role.slug = parsed_hero_data['role']['slug']
    role.name = parsed_hero_data['role']['name']
    role.description = parsed_hero_data['role']['description']
    role.save
    hero.role_id = role.id

    # Saving time to get the id
    hero.save

    # Stats
    stat = Stat.find_by_hero_id(hero.id)
    stat = Stat.new if stat.nil?
    stat.damage = parsed_hero_data['stat']['damage']
    stat.utility = parsed_hero_data['stat']['utility']
    stat.survivability = parsed_hero_data['stat']['survivability']
    stat.complexity = parsed_hero_data['stat']['complexity']
    stat.hero_id = hero.id
    stat.save

    # Save the hero with the updated details
    hero.stat_id = stat.id
    hero.save
    hero
  end

  def save_hero_to_disk(data)
    return if data.nil? || data['name'].nil?
    name = data['name']
    ApplicationHelper.create_directory(Rails.configuration.local_hero_folder)
    hero = JSON.pretty_generate(data)
    backup_hero_on_disk name
    File.open(Rails.configuration.hero_local_file % name, 'w') { |file| file.write(hero) }
  end

  def backup_hero_on_disk(name)
    current_file_name = Rails.configuration.hero_local_file % name
    (1..100).reverse_each do |backup|
      previous_backup_dir = File.join([Rails.configuration.local_hero_folder, (backup - 1).to_s])
      next_backup_dir = File.join([Rails.configuration.local_hero_folder, backup.to_s])
      src_file_name = (backup == 1) ? current_file_name : File.join([previous_backup_dir, "#{name}.json"])
      dest_file_name = File.join([next_backup_dir, "#{name}.json"])

      ApplicationHelper.create_directory(next_backup_dir)

      # 20 we are done
      if backup == 20 && File.exists?(dest_file_name)
        next
      end

      next if !File.exists?(src_file_name)
      FileUtils.mv(src_file_name, dest_file_name)
      puts "COPYING: #{src_file_name}\nTO: #{dest_file_name}\n\n"
    end
  end
end
