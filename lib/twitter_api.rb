require './lib/nomlish_api'
require 'net/http'
require 'uri'
require 'json'
require 'oauth'
#require 'twitter'

module TwitterAPI
  TWEET_STREAM = URI.parse('https://userstream.twitter.com/1.1/user.json?track=RND_cpp')
  class User
  attr_accessor :name, :screen_name
    def initialize(json)
      @name = json['name']
      @screen_name = json['screen_name']
    end
  end
  class Status
  attr_accessor :user, :text
    def initialize(json)
      @user = User.new(json['user'])
      @text = json['text']
    end
    def self.set_filter(&block)
      @@filter_block = block
    end
    def filter
      @@filter_block.call(self)
    end
  end
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
        p 'TwitterAPI init'
    end
    def connect_stream
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
                yield(Status.new(JSON.parse(line))) rescue next
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
    def update(text)
      p @@access_token.post('https://api.twitter.com/1.1/statuses/update.json',{'status'=>text})
    end
  end
end
