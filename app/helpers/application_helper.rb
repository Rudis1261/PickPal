module ApplicationHelper
  def self.error(message = false)
    {
      :error => true,
      :message => message ||= 'Unable to process your request'
    }.to_json
  end
end
