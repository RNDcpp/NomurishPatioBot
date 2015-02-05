require './lib/nomlish_api'
require 'net/http'
require 'uri'
require 'json'
require 'oauth'

module TwitterAPI
  TWEET_STREAM = URI.parse('https://userstream.twitter.com/1.1/user.json?track=RND_cpp')
  class << self
    def init(file_name)
      config_file = YAML.load_file file_name
        @@consumer = OAuth::Consumer.new(
          config_file['consumer_key'],
          config_file['consumer_key_secret'],
          site: 'http://twitter.com'
        )
        @@access_token = OAuth::AccessToken.new(
          @@consumer,
          config_file['oauth_token'],
          config_file['oauth_token_secret']
        )
        @@client = Twitter::REST::Client.new do |config|
          config.consumer_key        = config_file['consumer_key']
          config.consumer_secret     = config_file['consumer_key_secret']
          config.access_token        = config_file['oauth_token']
          config.access_token_secret = config_file['oauth_token_secret']
        end
        p 'TwitterAPI init'
    end
    def connect_streem
      https = Net::HTTP.new(TWEET_STREAM.host,TWEET_STREAM.port)
      https.use_ssl = true
      https.ca_file = './ca_file/userstream.twitter.com'
      https.verify_mode = OpenSSL::SSL::VERIFY_PEER
      https.verify_depth = 5
      https.start do |https|
        p 'start https'
        request = Net::HTTP::Get.new(TWEET_STREAM.request_uri)
        request["User-Agent"] = 'Nomurish Patio Bot'
        request.oauth!(https,@@consumer,@@access_token)
        buf = ''
        https.request(request)do |response|
          raise "Response is not Chunked \n #{response.read_body}" unless response.chunked?
          response.read_body do |chunk|
            p 'response chunk'
            buf << chunk
            while(line = buf[/.+?(\r\n)+/m]) != nil
              begin
                buf.sub!(line,"")
                line.strip!
                status = JSON.parse(line) rescue next
                user = status['user']
                puts "#{user['screen_name']}:#{status['text']}"
              rescue
              end
            end
          end
        end
      end
    end
    def find_by_user_name(user_name)
      @@client.user(user_name)
    end
  end
end
