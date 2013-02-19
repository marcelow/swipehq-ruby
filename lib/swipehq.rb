require "swipehq/version"

module SwipeHQ
  extend self

  LIB_PATH = File.dirname(__FILE__) + '/swipehq/'

  @@api_key = nil

  def configure
    yield self
  end

end
