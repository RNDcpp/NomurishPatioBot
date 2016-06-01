require 'net/http'
require 'uri'
require 'nokogiri'

module NomlishAPI
  URL = URI::parse('http://racing-lagoon.info/nomu/translate.php').freeze
  OPTIONS = ['no_chk', 'an_chk', 'only_auto_chk']

  class << self
    def translate(msg, level: 2, option: 'no_chk')
      msg = msg.to_s
      option = option.to_s

      raise ArgumentError, 'option should be in constant OPTIONS' unless OPTIONS.include?(option)
      raise ArgumentError, 'level should be Integer' unless level.is_a?(Integer)
      raise ArgumentError, 'level should fall in 1 to 5' unless (1..5).include?(level.to_i)

      form_data = {
        'before' => msg,
        'level'  => level.to_s,
        'after'  => '',
        'options' => option.delete('_'),
        'transbtn' => '翻訳',
        'new_japanese' => '',
        'new_nomrish'  => ''
      }
      response = post_request(form_data)

      nokogiri = Nokogiri::parse(response.body)
      return nokogiri.css("textarea").last.child.to_s.strip
    end

    private
    def post_request(form_data)
      req = Net::HTTP::Post.new(URL.path)
      req['Referer'] = 'http://racing-lagoon.info/nomu/translate.php'
      req['User-Agent'] = 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/40.0.2214.93 Safari/537.36)'
      req.form_data = form_data
      return Net::HTTP.new(URL.host, URL.port).start {|http| http.request(req) }
    end
  end
end
