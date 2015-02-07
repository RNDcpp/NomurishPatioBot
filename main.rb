require 'sinatra'
#require './bot'
require './lib/nomlish_api'

$streaming = proc do
  begin
    # Bot.init 'BotConfig.yaml'
    puts "start"
    loop do
      sleep 1
    end
  ensure
    # Bot stop process
    puts "end"
  end
end
$streaming_thread = Thread.new(&$streaming)

#ConsoleScreenProcess
class Console < Sinatra::Base
  get '/' do
    erb :index
  end

  get '/edit' do
    erb :edit
  end

  post '/stop' do
    $streaming_thread.kill
    redirect '/'
  end

  post '/run' do
    $streaming_thread = Thread.new(&$streaming) unless $streaming_thread.alive?
    redirect '/'
  end
end

#Console.run!
