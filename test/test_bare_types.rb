require_relative 'helper'

app do
  key :some_string, String
  key :some_number, Numeric
  key :some_hash, Hash
  key :some_array, Array
end

it_accepts some_string: 'which is non-empty',
  some_number: 0,
  some_hash: { 'with a key' => 'and a value' },
  some_array: ['with an element']

it_rejects some_string: '', some_number: 0, some_hash: {}, some_array: []
it_rejects some_string: 42,
  some_number: 0,
  some_hash: { 'with a key' => 'and a value' },
  some_array: ['with an element']
it_rejects some_string: 'which is non-empty',
  some_number: 'not a number',
  some_hash: { 'with a key' => 'and a value' },
  some_array: ['with an element']
it_rejects some_string: 'which is non-empty',
  some_number: 0,
  some_hash: 'not a hash',
  some_array: ['with an element']
it_rejects some_string: 'which is non-empty',
  some_number: 0,
  some_hash: { 'with a key' => 'and a value' },
  some_array: 'not an array'
