require 'sinatra'
#require './bot'
require './lib/nomlish_api'
begin
  STREAMING = Thread.new do
    Thread.handle_interrupt(RuntimeError=>:on_blocking) do
#      Bot.init 'BotConfig.yaml'
      if Thread.pending_interrupt?
        sleep 1
        #TODO TwitterBot processe will be written here
      end
    end
  end
  STREAMING.join
rescue
  #TODO TwitterBot send error
end
#ConsoleScreenProcess
class Console < Sinatra::Base
  get '/' do
    erb :index
  end

  get '/edit' do
    erb :edit
  end

  post '/stop' do
    STREAMING.raise
    redirect back
  end

  post '/run' do
    STREAMING.run
    redirect back
  end
end
Console.run!
