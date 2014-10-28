require 'bundler/setup'
require 'test/unit'
require 'turn/autorun'
require 'shoulda'
require 'mocha/setup'

#Turn.config.format = :dot

$LOAD_PATH << 'lib'

class TestCase < Test::Unit::TestCase
end
