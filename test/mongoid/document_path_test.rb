require 'test_helper'

class Mongoid::DocumentPathTest < Minitest::Test
  class Order
    include Mongoid::Document
    include Mongoid::DocumentPath
  end

  def test_that_it_has_a_version_number
    refute_nil ::Mongoid::DocumentPath::VERSION
  end

  def test_root_object_document_paths
    order = Order.create!
    document_path = order.document_path

    assert_equal(document_path.length, 1)
    assert_equal(document_path.first.type, Order.name)
    assert_equal(document_path.first.document_id, order.id.to_s)
    assert_nil(document_path.first.relation)

    assert_equal(Mongoid::DocumentPath.find(document_path), order)
  end
end
