# TwitterHog!

This is a response to the [StackCommerce Dev Challenge](https://github.com/stacksocial/code-challenge/tree/master/ruby/rails-twitter-api)

Check it out in action [here](//frozen-earth-17440.herokuapp.com)

### Local Setup
Before booting up, make sure to set the following ENV variables:

    export TWITTER_CONSUMER_KEY=1234567890
    export TWITTER_CONSUMER_SECRET=xyzzx
    export REDIS_HOST_URI=localhost
    export REDIS_PORT=6379

To get a Twitter API key (in case you don't already know...) visit the [Twitter Dev Site](https://dev.twitter.com/resources/signup), sign up and create a new app.

The Redis variables shown are default values, so if yours are the same you can omit them. That said, at the moment there is no failover if the app can't connect to Redis - a redis server is **mandatory**.

After that boot up with `rails s`, head to `localhost:3000` and hit sign up.

### Basic Design Rundown

###### Authentication
I'm using [Devise](https://github.com/plataformatec/devise) for authentication, which should come as no surprise. Initially I considered using its OAuth extension to handle signups/logins with Twitter OAuth, but as Twitter allows API access with just an application API key pair, this seemed unnecessary; a simple email/password login will suffice for now.

###### API Access
The [twitter](https://github.com/sferik/twitter) gem by sferik is by far the most popular gem for accessing Twitter's REST API, so that's a no-brainer. All code involved with accessing the Twitter API can be found in `lib/twitter_interface.rb`. This code was kept separate both in the interest of keeping concerns (not **C**oncerns...) organized, but also for the easy inclusion of `RedisWrap`. If the scope of the API access had been wider a different structure may have been warranted, but given that there are only 2 calls made, this keeps things succinct.

###### RedisWrap
This is derived from a Concern I had written for another project which would seamlessly integrate a redis layer into ActiveRecord. The full code isn't public at the moment, but I will publish a Gist soon, hopefully before this project is reviewed.

The core method of RedisWrap (in this context) is the `redis_or` method, which simply takes a key name and either returns the value for that key from redis, or if no value is set runs a block and saves the returned value to redis.

### Heroku Deploy
This app is already live on [Heroku](//frozen-earth-17440.herokuapp.com), but let's say you want to start from scratch.

* Visit Heroku.com and sign up/log in, and create a new app.
* If you haven't already, `git clone` this repo to your local machine, then `cd twitter_hog`
* Also if you haven't already, install heroku toolbelt with homebrew: `brew update && brew install heroku`, then `heroku login` and enter your credentials
* At that point you'll be able to add the heroku git remote with `heroku git:remote -a <your-app-name>`, then `git push heroku master` to start the deploy process.
* set up a redis server with `heroku addon:create redistogo:nano`
* time to `heroku open` and play around!

### Testing
I would have hoped to have a more complete test suite, but time has run short. The main holdup was mocking up the Twitter API, which is an extensive task. Might come back to it and add more tests tomorrow.
