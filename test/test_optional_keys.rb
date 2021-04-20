require_relative 'helper'

app do
  key :first, String

  optional {
    key :second, String
  }
end

it_accepts first: 'some string'
it_accepts first: 'some string', second: 'another string'
it_rejects first: 'some string', second: 42
