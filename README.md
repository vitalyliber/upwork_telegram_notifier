# UpWork Instagram notifier

## Getting Started

Install dependencies

```
bundle install
```

Set environment variables in the .env file or globally

```
TELEGRAM_API_TOKEN=xxx:xxx
RSS_LINKS="https://www.upwork.com/ab/feed/jobs/rss?contractor_tier=2%2C3&proposals=0-4&q=ruby+on+rails&sort=recency&job_type=hourly&pa https://www.upwork.com/ab/feed/jobs/rss?proposals=0-4&q=react+native&sort=recency&job_type=hourly&paging=0%3B10&api_params="
TELEGRAM_CHANNELS="upwork_ror_notifier upwork_rn_notifier"
```

Run the UpWork notifier

```
ruby main.rb
```

## How to configure telegram channel

- Create a Telegram public channel
- Create a Telegram BOT via BotFather
- Set the bot as administrator in your channel
- Set the bot api token to environment variable `TELEGRAM_API_TOKEN`