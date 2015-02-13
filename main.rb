require 'sinatra'
require './lib/bot_logger'
require './bot'
#ConsoleScreenProcess
class Console < Sinatra::Base
set :environment, :production
@@Bot = Bot.new
  get '/' do
    @bot=@@Bot
    erb :index
  end

  get '/log/tweet' do
    @tweet = File.read('./log/tweet.log')
  end

  get '/log/message' do
    @tweet = File.read('./log/message.log')
  end

  get '/log/response' do
    @tweet = File.read('./log/response.log')
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
Console.run!
