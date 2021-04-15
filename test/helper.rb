require 'minitest'
Minitest.autorun

module Minitest::Assertions
  def is subject, predicate
    fail <<~S

     Subject: #{subject}
     Predicate: #{predicate}
    S
  end
end

require 'hobby'
require 'hobby/json/keys'

def app &block
  app = Class.new do
    include Hobby
    include Hobby::JSON::Keys

    instance_exec &block
  end

  p app
  $app_socket = app
end

def it name, &block
  Class.new Minitest::Test do
    define_method "test_ #{name}", &block
  end
end
