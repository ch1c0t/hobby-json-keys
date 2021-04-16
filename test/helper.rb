require 'minitest'
Minitest.autorun

module Minitest::Assertions
  def is subject, predicate
    assert_equal predicate, subject
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
  socket = "#{DIR}/#{name}.#{Time.now.to_i}.#{SecureRandom.uuid}"

  pid = fork do
    server = Puma::Server.new app.new
    server.add_unix_listener socket
    server.run
    sleep
  end

  sleep 0.1 until File.exist? socket
  APPS[name] = {
    pid: pid,
    socket: socket,
  }
end

def it summary, &block
  name = File.basename caller_locations.first.path, '.rb'
  pid, socket = APPS[name].values_at :pid, :socket

  Class.new Minitest::Test do
    define_method :teardown do
      Process.kill 9, pid
      File.delete socket if File.exist? socket
    end

    define_method "#{name}(it #{summary})", &block
  end
end
