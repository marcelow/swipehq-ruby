require "swipehq/version"

module SwipeHQ
  extend self

  LIB_PATH = File.dirname(__FILE__) + '/swipehq/'

  def configure
    yield self
  end

  def api_key
    @api_key ||= nil
  end

end
