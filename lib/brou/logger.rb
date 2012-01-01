require 'logger'

module Brou::Logger

  def logger
    @logger ||= Logger.new('tmp/log')
  end

  def log str
    logger.debug "#{str}\n"
  end
end
