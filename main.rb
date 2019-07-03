require 'dotenv/load'
require 'rss'
require 'open-uri'
require 'nokogiri'

@instagram_api_token = ENV.fetch("INSTAGRAM_API_TOKEN")

@checked = {}
channels = [
    {
        url: 'https://www.upwork.com/ab/feed/jobs/rss?contractor_tier=2%2C3&proposals=0-4&q=ruby+on+rails&sort=recency&job_type=hourly&pa',
        channel: 'upwork_ror_notifier',
        cold_start: true,
    },
    {
        url: 'https://www.upwork.com/ab/feed/jobs/rss?proposals=0-4&q=react+native&sort=recency&job_type=hourly&paging=0%3B10&api_params=',
        channel: 'upwork_rn_notifier',
        cold_start: true
    }
]

def check_rss(channel)
  rss = open(channel[:url])
  feed = RSS::Parser.parse(rss)
  puts "Title: #{feed.channel.title}"
  item = feed.items.last
  unless @checked[item.link]
    puts "Item: #{item.title}"
    @checked[item.link] = true
    if channel[:cold_start]
      return channel[:cold_start] = false
    end
    plain_text = Nokogiri::HTML(item.description).text
    plain_text = "#{item.link}\n\n#{plain_text}"
    instagram_channel_url = "https://api.telegram.org/bot#{@instagram_api_token}/sendMessage?chat_id=@#{channel[:channel]}&text=#{plain_text}"
    instagram_channel_url = URI.parse(URI.escape(instagram_channel_url))
    open(instagram_channel_url)
  end
end

while true
  channels.each do |channel|
    check_rss(channel)
    sleep 5
  end
end