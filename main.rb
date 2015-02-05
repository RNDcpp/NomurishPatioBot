require './bot'
require './lib/twitter_api'
require 'twitter'

TwitterAPI.init('BotConfig.yaml')
TwitterAPI.connect_streem
