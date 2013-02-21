require 'bundler/setup'
require 'rest_client'
require 'json'

require "swipehq/version"
require "swipehq/transaction"

module SwipeHQ
  extend self

  LIB_PATH = File.dirname(__FILE__) + '/swipehq/'

  def configure
    yield self
  end

  %w{ api_key merchant_id callback_url lpn_url }.each do |setting|
    define_method "#{setting}" do
      instance_variable_get("@#{setting}") || instance_variable_set("@#{setting}", nil)
    end

    define_method "#{setting}=" do |value|
      instance_variable_set("@#{setting}", value)
    end
  end

  def request(method = :get, url, params)
    raw_response = RestClient.send(method, url, params: params)
    if raw_response
      JSON.parse(raw_response)
    else
      nil
    end
  end

  def set_callback_url
    return nil unless callback_url
    params = {
      api_key: SwipeHQ.api_key,
      merchant_id: SwipeHQ.merchant_id,
      callback_url: callback_url
    }
    url = 'https://api.swipehq.com/setCallback.php'
    request(:post, url, params: params)
  end

  def set_lpn_url
    return nil unless lpn_url
    params = {
      api_key: SwipeHQ.api_key,
      merchant_id: SwipeHQ.merchant_id,
      lpn_url: lpn_url
    }
    url = 'https://api.swipehq.com/setCallback.php'
    request(:post, url, params: params)
  end

end
