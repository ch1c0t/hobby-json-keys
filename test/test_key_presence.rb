require_relative 'helper'

app do
  key :first
  key :second
end

it_accepts first: 1, second: 2
it_rejects third: 3

it 'accepts excessive input' do
  excon = Excon.new 'unix:///', socket: socket, headers: {
    'Content-Type'  => 'application/json',
  }

  input = {
    first: :a,
    second: :b,
    excessive: :c,
  }
  response = excon.post body: input.to_json
  is response.status, 200

  keys = JSON.parse response.body
  is keys, {
    'first' => 'a',
    'second' => 'b',
  }
end
