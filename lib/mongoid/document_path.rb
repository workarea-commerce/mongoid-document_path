require 'mongoid'
require 'mongoid/document_path/version'
require 'mongoid/document_path/node'

module Mongoid
  module DocumentPath
    extend ActiveSupport::Concern

    def self.find(path)
      return nil if path.blank?

      root = path.first.type.constantize.find(path.first.document_id)
      return root if path.one?

      path.reduce(root) do |current, node|
        relation_match = if node.matches?(current)
                           current
                         elsif current.respond_to?(:detect)
                           current.detect { |d| node.matches?(d) }
                         end

        if node.terminal?
          return relation_match
        else
          relation_match.send(node.relation)
        end
      end
    end

    def document_path(node = self, current_relation = nil)
      relation = node.embedded? ? node.metadata_name.to_s : nil
      list = node._parent ? document_path(node._parent, relation) : []

      list << Node.new(
        type: node.class.name,
        document_id: node.id,
        relation: current_relation
      )

      list
    end
  end
end
