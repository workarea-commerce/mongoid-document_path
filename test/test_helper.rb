$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'mongoid/document_path'

require 'minitest/autorun'
require 'minitest/reporters'

Mongoid.configure do |config|
 config.connect_to('mongoid_audit_log_test')
end

Minitest::Reporters.use! [
 Minitest::Reporters::DefaultReporter.new(color: true)
]

class MiniTest::Unit::TestCase
  def before_setup
    Mongoid.purge!
  end
end
