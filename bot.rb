# coding: utf-8
require './lib/nomlish_api'
require './lib/twitter_api'
require './lib/nomlish_api'
require './lib/bot_logger'
require 'yaml'
require 'pp'
class Bot

  def initialize(config_file:'BotConfig.yml',follower_list:'Followers.yml')
    BotLog.init
    f_list = YAML.load_file follower_list
    pp f_list
    TwitterAPI::Status.set_filter do |status|
      (f_list.include?(status.user.screen_name))and(!status.text.include?('@'))and(status.retweet==nil)
    end
    @streaming_proc = proc do
      begin
        BotLog.message.debug 'start'
        TwitterAPI.init(config_file)
        TwitterAPI.connect_stream do |status|
          BotLog.message.debug 'tweet:'
          BotLog.tweet.debug "#{status.user.screen_name}:#{status.text}"
          if status.filter
            BotLog.message.debug 'tweet translate'
            text = NomlishAPI.translate(status.text)
            BotLog.message.debug text
            if text.length <= 140
               begin 
                 TwitterAPI.update(text)
                 BotLog.message.debug 'tweet!'
               rescue
                 BotLog.errors.debug 'tweet update error'
               end
            end
          end
        end
      ensure
        # Bot stop process
        BotLog.message.debug "end"
      end
    end
    @streaming_thread = Thread.new(&@streaming_proc)
  end

  def alive
    @streaming_thread.alive?
  end

  def stop!
    @streaming_thread.kill
  end

  def run!
    @streaming_thread = Thread.new(&@streaming_proc) unless alive
  end

  def reload
    stop!
    run!
  end
end
