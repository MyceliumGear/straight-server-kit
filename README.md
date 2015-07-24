# StraightServerKit

StraightServerKit is the official [StraightServer API]() client. It supports everything the API can do with a simple interface written in Ruby.

[![Build Status](https://travis-ci.org/MyceliumGear/straight-server-kit.svg?branch=master)](https://travis-ci.org/MyceliumGear/straight-server-kit)

## Installation

Add this line to your application's Gemfile:

    gem 'straight-server-kit'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install straight-server-kit

## Usage

```ruby
client = StraightServerKit::Client.new(gateway_id: 'gateway_id', secret: 'secret', url: 'http://gear.loc')
```

## Order resource

    client = StraightServerKit::Client.new(gateway_id: 1, secret: 'secret')
    client.orders #=> StraightServerKit::OrderResource

Actions supported:

* `client.orders.create(order)`
* `client.orders.find(id: 'id')`
* `client.orders.cancel(id: 'id')`

### Order creation

    order = StraightServerKit::Order.new(amount: 0.01, callback_data: '123', keychain_id: 1)
    client.orders.create(order)

### Callback validation

    if StraightServerKit.valid_callback?(signature: env['HTTP_X_SIGNATURE'], request_uri: (URI(env['REQUEST_URI']).request_uri rescue env['REQUEST_URI']), secret: gateway_secret)
      # params can be trusted
    end

## Contributing

1. Fork it ( https://github.com/MyceliumGear/straight-server-kit )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
