## Introduction

`hobby-json-keys` is a [Hobby][hobby] extension to parse JSON requests.
It is available on Rubygems at [hobby-json-keys][rubygems].

After including it into your app, you can use the `key` method to define
which keys will be accepted by the app. To access these keys, you can use
`keys`(a Ruby Hash) in your routes.

## Usage example

```ruby
require 'hobby'
require 'hobby/json/keys'

class App
  include Hobby
  include JSON::Keys

  # This defines that 'fn' and 'in' must be present
  # in every request body. Otherwise: 400, bad request.
  key :fn
  key :in

  # The route definition for POST requests is below
  post {
    keys # => { fn:, in: }
         # a Hash with the defined keys
    
    # The latest object here gets converted #to_json
    # and sent back as a response.
  }
end
```

## `key` method

With one argument(`key :name`), it will check only the key presence.

With two arguments(`key :name, type`), it will also check that the
key's value has an appropriate type. Any object that implements `.===`
can be used as a `type`.

## Non-empty defaults for Strings, Arrays, and Hashes

`""`, `[]`, `{}` will be rejected if you define the keys as follows:

```ruby
key :some_string, String
key :some_array, Array
key :some_hash, Hash
```

To accept empty values, you can extend the types as follows:

```ruby
key :some, String {
  may_be_empty
}
```

## Optional keys

By default, all defined keys are required. You can define optional ones
inside of the `optional` block:

```ruby
key :fn

optional {
  key :in
}
```

## Development

To build the project and run the tests:

`bundle exec rake`

[hobby]: https://github.com/ch1c0t/hobby
[rubygems]: https://rubygems.org/gems/hobby-json-keys
