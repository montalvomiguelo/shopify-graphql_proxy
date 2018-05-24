# shopify-graphql_proxy
Gem to securely proxy graphql requests to Shopify from Rack based Apps

* Avoid CORS complications by proxying from same domain to Shopify
* Allows client side scripts to query a logged in merchant's shop without needing to know the users acces token

## Installation
Add the following to your Gemfile
```
gem 'shopify-graphql_proxy', '-> 0.1.0'
```
Or install:
```
gem install shopify-graphql_proxy
```

## Usage
It is recommended to use the [omniauth-shopify-oauth2](https://github.com/Shopify/omniauth-shopify-oauth2) to authenticate requests with Shopify

```ruby
use Shopify::GraphQLProxy

```

This middleware expects that the session data is stored in the shopify key


```ruby
session[:shopify] = {
  shop: shop_name,
  token: token
}
```

It will proxy any `POST` request to `/graphql` on your app to the current logged in shop found in session

#### Get GraphQL data from client side with logged in merchant's shop
```javascript
fetch('/graphql', {
  method: 'POST',
  headers: { 'Content-Type': 'application/json' },
  body: JSON.stringify({ query: '{ shop { name } }' }),
  credentials: 'include'
})
  .then(res => res.json())
  .then(res => console.log(res.data));
```

## Custom path
You can use the Rack::Builder#map method to specify middleware to run under specific path
```ruby
# /shopify/graphql

map('/shopify') do
  use Shopify::GraphQLProxy
  run Proc.new { |env| [200, {'Content-Type' => 'text/plain'}, ['get rack\'d']]}
end

map('/') do
  run App
end
```

## Thanks

* [Rack Proxy](https://github.com/ncr/rack-proxy)
* [Koa Shopify GraphQL Proxy](https://github.com/Shopify/quilt/tree/master/packages/koa-shopify-graphql-proxy)
