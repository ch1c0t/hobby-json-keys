require_relative 'helper'

app do
  key :some, String {
    may_be_empty
  }
  key :filled, String {
    puts
  }
end

it_accepts some: 'non-empty', filled: 'filled'
it_accepts some: '', filled: 'filled'
it_rejects some: '', filled: ''
