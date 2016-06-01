require './console.rb'
patio = Bot.new
TwitterAPI::Status.set_filter do |status|
  (patio.f_list.include?(status.user.screen_name))and(!status.text.include?('@'))and(status.retweet==nil)
end
patio.set_proc{|status|
      BotLog.message.debug 'tweet:'
      BotLog.tweet.debug "#{status.user.screen_name}:#{status.text}"
      if status.filter
        BotLog.message.debug 'tweet translate'
        text = NomlishAPI.translate(status.text)
        BotLog.message.debug text
        if text.length <= 120
           begin 
             #text<<"\n https://twitter.com/#{status.user.screen_name}/status/#{status.id}"
             TwitterAPI.update(text,nil)
             BotLog.message.debug 'tweet!'
           rescue => e
             BotLog.errors.debug e.message
             BotLog.message.debug 'tweet update error'
           end
        end
      end
    }#end bot_process
Console.set_bot patio
Console.run!
