require 'minitest'
Minitest.autorun

require 'terminal-table'
require 'ap'
AwesomePrint.defaults = {
  indent: -2,
}

module Minitest::Assertions
  def is subject, predicate
    assert_equal predicate, subject
  end

  def assert_response response, expected_body, expected_status
    if (response.status != expected_status) || (response.body != expected_body)
      expected_keys = expected_body.empty? ? expected_body : (JSON.parse expected_body)
      keys = response.body.empty? ? response.body : (JSON.parse response.body)
      table = Terminal::Table.new headings: ['', 'Expected', 'Actual'],
        rows: [
          ['response.status', expected_status, response.status],
          ['keys', expected_keys.awesome_inspect, keys.awesome_inspect],
        ]
      fail "\n#{table}"
    end
  end
end

DIR = '/tmp/hobby-json-keys.tests'
Dir.mkdir DIR unless Dir.exist? DIR

require 'puma'
require 'excon'
require 'hobby'
require 'hobby/json/keys'
require 'securerandom'
require 'json'

APPS = {}

def app &block
  app = Class.new do
    include Hobby
    include Hobby::JSON::Keys

    instance_exec &block
  end

  name = File.basename caller_locations.first.path, '.rb'
  APPS[name] = app
end

module AppSetup
  def setup
    @pid = fork do
      server = Puma::Server.new app.new
      server.add_unix_listener socket
      server.run
      sleep
    end

    sleep 0.1 until File.exist? socket
  end

  def teardown
    Process.kill 9, @pid
    File.delete socket if File.exist? socket
  end
end

def test name, description, &block
  socket = "#{DIR}/#{name}.#{Time.now.to_i}.#{SecureRandom.uuid}"

  Class.new Minitest::Test do
    include AppSetup

    define_method :app do APPS[name] end
    define_method :socket do socket end
    define_method description, &block
  end
end

def it summary, &block
  name = File.basename caller_locations.first.path, '.rb'
  test name, "#{name}(it #{summary})", &block
end

def it_accepts input
  name = File.basename caller_locations.first.path, '.rb'
  test name, "#{name}(it_accepts #{input})",
    &TestAssertResponse.(input.to_json, 200)
end

def it_rejects input
  name = File.basename caller_locations.first.path, '.rb'
  test name, "#{name}(it_rejects #{input})",
    &TestAssertResponse.(input.to_json, 400, expected_body: '')
end

TestAssertResponse = -> request_body, expected_status, expected_body: request_body do
  -> {
    excon = Excon.new 'unix:///', socket: socket, headers: {
      'Content-Type'  => 'application/json',
    }

    response = excon.post body: request_body
    assert_response response, expected_body, expected_status
  }
end
