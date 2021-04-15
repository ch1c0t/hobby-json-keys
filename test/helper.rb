require 'minitest/autorun'

module Minitest::Assertions
  def is subject, predicate
    fail <<~S

     Subject: #{subject}
     Predicate: #{predicate}
    S
  end
end
