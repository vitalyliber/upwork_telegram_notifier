require 'dotenv/load'
require 'rss'
require 'open-uri'
require 'nokogiri'

p "Program started"

time_interval = 15
@telegram_api_token = ENV.fetch("TELEGRAM_API_TOKEN")

@checked = {}
rss_links = ENV.fetch("RSS_LINKS") {''}.split(' ')
telegram_channels = ENV.fetch("TELEGRAM_CHANNELS") {''}.split(' ')
channels = rss_links.each_with_index.map do |channel, index |
  {
      channel: telegram_channels[index],
      url: channel,
      cold_start: true
  }
end

def check_rss(channel)
  rss = open(channel[:url])
  feed = RSS::Parser.parse(rss)
  p "Title: #{feed.channel.title}"
  item = feed.items.first
  unless @checked[item.link]
    p "Item: #{item.title}"
    @checked[item.link] = true
    if channel[:cold_start]
      return channel[:cold_start] = false
    end
    plain_text = Nokogiri::HTML(item.description).text
    plain_text = "#{item.link}\n\n#{plain_text}"
    instagram_channel_url = "https://api.telegram.org/bot#{@telegram_api_token}/sendMessage?chat_id=@#{channel[:channel]}&text=#{plain_text}"
    instagram_channel_url = URI.parse(URI.escape(instagram_channel_url))
    open(instagram_channel_url)
  end
end

while true
  channels.each do |channel|
    check_rss(channel)
    sleep time_interval
  end
end