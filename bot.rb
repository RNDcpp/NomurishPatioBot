require 'yaml'
require 'tweetstream'
module Bot
  class << self

    def init(file_name)
      @@CONFIG = YAML.load_file file_name
      TweetStream.configure do |config|
        config.consumer_key        = @@CONFIG['consumer_key']
        config.consumer_secret     = @@CONFIG['consumer_key_secret']
        config.oauth_token         = @@CONFIG['oauth_token']
        config.oauth_token_secret  = @@CONFIG['oauth_token_secret']
        config.auth_method         = :oauth
      end
    end

    def run
      if @@CONFIG
        client = TweetStream::Client.new
        client.sample do |status|
          puts " #{status.user.name} -> #{status.text}\n\n" if validate_tweet
        end

        client.on_error do |message|
          $stderr.puts "[ERROR] #{message}"
        end

        client.on_reconnect do |timeout , retires|
          $stderr.puts "[RECONNECT] timeout: #{timeout} , retires: #{retires}"
        end

      end
    end
  end

  def validate_tweet
    return true
  end
  private:validate_tweet
end
