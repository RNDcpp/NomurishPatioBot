require 'logger'
module BotLog
  class << self
    attr_accessor :tweet,:message,:errors,:response
    def init
      File.write('./logger/tweet.log',nil)
      File.write('./logger/message.log',nil)
      File.write('./logger/errors.log',nil)
      File.write('./logger/response.log',nil)
      @tweet = Logger.new('./logger/tweet.log')
      @message = Logger.new('./logger/message.log')
      @errors = Logger.new('./logger/errors.log')
      @response = Logger.new('./logger/response.log')
    end
  end
end
