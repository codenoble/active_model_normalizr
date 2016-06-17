Active Model Normalizr
======================

[Normalizr](https://github.com/paularmstrong/normalizr)-like serialization for [Active Model Serializers](https://github.com/rails-api/active_model_serializers).

Active Model Normalizr provides a custom [adapter](https://github.com/rails-api/active_model_serializers/blob/master/docs/general/adapters.md) for Active Model Serializers. So you can write your serializers like you always have and the output will be in a normalizr-like format that's easy to use with [Redux](http://redux.js.org/) or [Flux](https://facebook.github.io/flux/).

Installation
------------

Add it to your `Gemfile`

```ruby
gem 'active_model_normalizr'
```

In a Rails initializer or somewhere similar:

```ruby
ActiveModelSerializers.config.adapter = ActiveModelSerializers::Adapter::Normalizr
```
