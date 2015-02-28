# NomurishPatioBot
It translates Patio's tweets into Nomurish.
## Initialization
1 bundle install


2 create 'NomurishPatioBot/BotConfig.yml'

```yaml:BotConfig.yml
consumer_key:        [YOUR_CONSUMER_KEY]
consumer_key_secret: [YOUR_CONSUMER_KEY_SECRET]
oauth_token:         [YOUR_OAUTH_TOKEN]
oauth_token_secret:  [YOUR_OAUTH_TOKEN_SECRET]
```

3 create 'NomurishPatioBot/Followers.yml'

```yaml:Followers.yml
- [screen name]
- [screen name]
- [screen name]
```
## Activating

```
bundle exec ruby run.rb
```
