require 'sinatra'
require './lib/bot_logger'
require './bot'
#ConsoleScreenProcess
class Console < Sinatra::Base
set :environment, :production
set :port,6664
def self.set_bot(bot)
  @@Bot = bot
end
@@Bot = Bot.new
  get '/' do
    @bot=@@Bot
    erb :index
  end

  get '/tweetlog' do
    @log = File.read('./logger/tweet.log')
    erb :log
  end

  get '/messagelog' do
    @log = File.read('./logger/message.log')
    erb :log
  end

  get '/responselog' do
    @log = File.read('./logger/response.log')
    erb :log
  end

  get '/errors' do
    @log = File.read('./logger/errors.log')
    erb :log
  end


  get '/edit' do
    erb :edit
  end

  post '/stop' do
    @@Bot.stop!
    redirect '/'
  end

  post '/run' do
    @@Bot.run!
    redirect '/'
  end
end
