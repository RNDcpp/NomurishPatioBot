require './lib/nomlish_api'
require 'yaml'
class Bot

  def initialize(config_file:'BotConfig.yml',follower_list:'Followers.yml')
    @streaming_proc = proc do
      begin
        puts "start"
        loop do
          sleep 1
        end
      ensure
        # Bot stop process
        puts "end"
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
