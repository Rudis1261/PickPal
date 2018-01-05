require 'fileutils'
module ApplicationHelper
  def self.error(message = false)
    {
      :error => true,
      :message => message ||= 'Unable to process your request'
    }.to_json
  end

  def self.valid_json?(json)
    JSON.parse(json)
    return true
  rescue JSON::ParserError => e
    return false
  end

  def self.create_directory(dir)
    return if File.directory?(dir)
    FileUtils.mkdir_p dir
  end
end
