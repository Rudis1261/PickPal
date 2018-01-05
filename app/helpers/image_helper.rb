require 'httparty'

module ImageHelper
  def self.get_images_from_hero(hero)
    return if hero.nil?
    hero = JSON.parse(hero)
    images = [hero['poster_image']]
    images << hero['trait']['image']

    hero['abilities'].each do |ability|
      images << ability['image']
    end

    hero['heroics'].each do |heroic|
      images << heroic['image']
    end

    return images
  end

  def self.image_name(image)
    "#{image.split('/').last}"
  end

  def self.local_image_url(hero, image)
    url = Rails.configuration.hostname
    url += "#{Rails.configuration.image_path}"
    url += "#{hero ? hero + '/': ''}"
    url += self.image_name image
    return url
  end

  def self.image_dir_path(hero)
    url = "/public#{Rails.configuration.image_path}"
    url += "#{hero ? hero + '/': ''}"
    return url
  end

  def self.pull_image(hero, image)
    self.create_hero_image_directories hero
    local_image = self.local_image_url(hero, image)
    image_file = self.path(
        [
            self.image_dir_path(hero),
            self.image_name(image)
        ])

    if File.exists?(image_file) && File.size?(image_file) && File.size?(image_file) > 1024
      return local_image
    end

    return local_image if local_image == image

    # Failure to get image, thread it out and save it
    #Thread.new do
      puts "SCRAPING IMAGE: #{image}"
      image_data = HTTParty.get(image)
      puts "RESP #{image_data.code}"
      if !image_data || image_data.code != 200 || !image_data.parsed_response
        return image
      end

      # Great success
      self.save_image_to_disk(image_file, image_data.parsed_response)
    #end

    return image
  end

  def self.path(parts=[])
    after_parts = []
    parts.each do |part|
      after_parts << part.split('/').reject { |p| p.empty? }.join('/')
    end
    after_parts.join('/')
  end

  def self.create_hero_image_directories(hero_slug)
    hero_image_path = self.path([self.image_dir_path(hero_slug)])
    ApplicationHelper.create_directory hero_image_path
  end

  def self.save_image_to_disk(path, data)
    File.open(path, 'wb') { |file| file.write(data) }
  end

  # def self.purge
  #   FileUtils.rm_rf("./public#{Rails.configuration.image_path}") rescue 'Failed to delete images'
  # end
end
