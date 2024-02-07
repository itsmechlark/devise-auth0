# Devise Auth0

[![Release](https://github.com/itsmechlark/devise_auth0/actions/workflows/release.yml/badge.svg)](https://github.com/itsmechlark/devise_auth0/actions/workflows/release.yml)
[![Gem Version](https://badge.fury.io/rb/devise_auth0.svg)](https://badge.fury.io/rb/devise_auth0)
[![Coverage Status](https://coveralls.io/repos/github/itsmechlark/devise_auth0/badge.svg)](https://coveralls.io/github/itsmechlark/devise_auth0)
[![Maintainability](https://api.codeclimate.com/v1/badges/c4d85f1902fe21086b26/maintainability)](https://codeclimate.com/github/itsmechlark/devise_auth0/maintainability)

[`devise_auth0`](https://github.com/itsmechlark/devise_auth0) is a devise extension which uses Auth0 JWT tokens for user authorization based on [`devise-jwt`](https://github.com/waiting-for-dev/devise-jwt) and [`cancancan`](https://github.com/CanCanCommunity/cancancan), and authentication using [Auth0 for OmniAuth](https://github.com/auth0/omniauth-auth0).

### Installation

Add this line to your application's Gemfile:

```ruby
# Using Github Packages
source 'https://rubygems.pkg.github.com/itsmechlark' do
  gem 'devise_auth0'
end

# Using RubyGems
gem 'devise_auth0'
```

Read [this document from Github](https://docs.github.com/en/packages/working-with-a-github-packages-registry/working-with-the-rubygems-registry#installing-a-package) on how to install package.

### Usage

#### Devise configuration

First of all, you have to configure the creadentials to validate the authentication. You can do it in the devise initializer:

```ruby
Devise.setup do |config|
  # ...
  config.auth0 do |auth0|
    auth0.omniauth = true # default is false
    auth0.domain = ENV['AUTH0_DOMAIN']
    auth0.custom_domain = ENV['AUTH0_CUSTOM_DOMAIN'] # optional if you have a custom domain
    auth0.aud = ENV['AUTH0_AUDIENCE']
    auth0.client_id = ENV['AUTH0_CLIENT_ID']
    auth0.client_secret = ENV['AUTH0_CLIENT_SECRET']
  end
end
```

By default, we will use RS256 algorithm. OmniAuth can only be enable in single module due to it's limitation.

#### Model configuration

You have to tell which user models you want to be able to authorize with JWT tokens. For them, the authentication process will be like this:

- A user authenticates through Auth0.
- The client can use this token to authenticate following requests for the same user, providing it in the Authorization request header, also with format `Bearer #{token}`.

An example configuration:

```ruby
class AdminUser < ApplicationRecord
  devise :database_authenticatable, :auth0,
    auth0_options: { # Model level configuration 
      email_domains_allowlist: ["example.com"] # Only firstcircle.com users can be created
    }
end

class User < ApplicationRecord
  devise :database_authenticatable, :auth0,
    auth0_options: { # Model level configuration
      aud: ENV['AUTH0_USER_AUDIENCE'], # Audience for the JWT token especially for users
      email_domains_blocklist: ["example.com"], # example.com users will not be created
      omniauth: false # We will use the default authentication strategy (JWT with Client)
    }
end
```

Note: if you are making cross-domain requests, make sure that you add Authorization header to the list of allowed request headers and exposed response headers. You can use something like [rack-cors](https://github.com/cyu/rack-cors) for that, for example:

```ruby
config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins 'http://example.com'
    resource '/api/*',
      headers: %w(Authorization),
      methods: :any,
      expose: %w(Authorization),
      max_age: 600
  end
end
```

#### Check Abilities

The current user's permissions can then be checked using the `can?` and `cannot?` methods in views and controllers.

```ruby
<% if can? :read, @book %>
  <%= link_to 'View', @book %>
<% end %>
```

Or directly using the current user instance:

```ruby
current_user.can? :read, @book
current_user.cannot? :delete, @book
```

### Controller helpers

```ruby
# Inside your protected controller
before_action :authenticate_admin! # This will only allow admin users
before_action :authenticate_user! # This will only allow users
before_action :authenticate_auth0! # This will allow all configured users

def show
  @book = Book.find(params[:id])
  authorize! :read, @book
end
```
