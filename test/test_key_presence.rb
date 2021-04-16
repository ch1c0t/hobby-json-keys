require_relative 'helper'

app do
  key :first
  key :second

  post do
    keys
  end
end

it 'accepts excessive input' do
  socket = APPS[File.basename __FILE__, '.rb'][:socket]
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
