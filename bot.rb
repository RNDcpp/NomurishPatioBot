# coding: utf-8
require './lib/nomlish_api'
require './lib/twitter_api'
require './lib/nomlish_api'
require './lib/bot_logger'
require 'yaml'
require 'json'
require 'pp'
class Bot
attr_accessor :f_list
  def initialize(config_file:'BotConfig.yml',follower_list:'Followers.yml')
    BotLog.init
    @f_list = YAML.load_file follower_list
    pp @f_list
    @bot_proc = proc do |status|
      BotLog.message.debug 'tweet:'
      BotLog.tweet.debug "#{status.user.screen_name}:#{status.text}"
    end
    @streaming_proc = proc do
      begin
        BotLog.message.debug 'start'
        TwitterAPI.init(config_file)
        loop do
          TwitterAPI.connect_stream(&@bot_proc)
        end
      rescue=>e
        BotLog.errors.debug e.message
      ensure
        # Bot stop process
        BotLog.message.debug "end"
      end
    end
    @streaming_thread = Thread.new(&@streaming_proc)
  end

  def set_proc(&proc)
    @bot_proc = proc
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
