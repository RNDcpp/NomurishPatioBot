require 'sinatra'
require './bot'
#ConsoleScreenProcess
class Console < Sinatra::Base
set :environment, :production
@@Bot = Bot.new
  get '/' do
    @bot=@@Bot
    erb :index
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
