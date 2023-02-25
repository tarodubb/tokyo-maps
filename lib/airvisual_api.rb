require 'httparty'

module AirVisualApi
  include HTTParty
  base_uri 'https://api.airvisual.com'
  format :json

  def self.configure
    yield self
  end

  def self.get(path, options = {})
    options[:query] ||= {}
    options[:query].merge!(key: @api_key)
    super(path, options)
  end

  private

  def self.api_key=(value)
    @api_key = value
  end
end
