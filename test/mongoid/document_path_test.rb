require 'test_helper'

class Mongoid::DocumentPathTest < Minitest::Test
  class Order
    include Mongoid::Document
    include Mongoid::DocumentPath

    embeds_one :customer
    embeds_many :items
  end

  class Customer
    include Mongoid::Document
    include Mongoid::DocumentPath

    embedded_in :order
  end

  class Item
    include Mongoid::Document
    include Mongoid::DocumentPath

    embedded_in :order
    embeds_one :product
  end

  class Product
    include Mongoid::Document
    include Mongoid::DocumentPath

    embedded_in :item
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

  def test_embedded_object_document_paths
    order = Order.create!
    customer = order.create_customer
    document_path = customer.document_path

    assert_equal(document_path.length, 2)

    assert_equal(document_path.first.type, Order.name)
    assert_equal(document_path.first.document_id, order.id.to_s)
    assert_equal(document_path.first.relation, 'customer')

    assert_equal(document_path.second.type, Customer.name)
    assert_equal(document_path.second.document_id, customer.id.to_s)
    assert_nil(document_path.second.relation)

    assert_equal(Mongoid::DocumentPath.find(document_path), customer)
  end

  def test_embedded_collection_document_paths
    order = Order.create!
    order.items.create!
    item = order.items.create!
    document_path = item.document_path

    assert_equal(document_path.length, 2)

    assert_equal(document_path.first.type, Order.name)
    assert_equal(document_path.first.document_id, order.id.to_s)
    assert_equal(document_path.first.relation, 'items')

    assert_equal(document_path.second.type, Item.name)
    assert_equal(document_path.second.document_id, item.id.to_s)
    assert_nil(document_path.second.relation)

    assert_equal(Mongoid::DocumentPath.find(document_path), item)
  end

  def test_double_embedded_document_paths
    order = Order.create!
    order.items.create!
    item = order.items.create!
    product = item.create_product
    document_path = product.document_path

    puts document_path.inspect
    assert_equal(document_path.length, 3)

    assert_equal(document_path.first.type, Order.name)
    assert_equal(document_path.first.document_id, order.id.to_s)
    assert_equal(document_path.first.relation, 'items')

    assert_equal(document_path.second.type, Item.name)
    assert_equal(document_path.second.document_id, item.id.to_s)
    assert_equal(document_path.second.relation, 'product')

    assert_equal(document_path.third.type, Product.name)
    assert_equal(document_path.third.document_id, product.id.to_s)
    assert_nil(document_path.third.relation)

    assert_equal(Mongoid::DocumentPath.find(document_path), product)
  end
end
