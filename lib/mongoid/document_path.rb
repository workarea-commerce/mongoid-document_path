require 'mongoid'
require 'mongoid/document_path/version'

module Mongoid
  module DocumentPath
    class Node
      include Mongoid::Document

      field :type, type: String
      field :document_id, type: String
      field :relation, type: String
      embedded_in :document_path, polymorphic: true
    end

    extend ActiveSupport::Concern

    class << self
      def find(path)
        return nil if path.blank?

        root = path.first.type.constantize.find(path.first.document_id)
        return root if path.one?

        path.reduce(root) do |current, path|
          relation_match = if document_path_matches?(path, current)
                             current
                           elsif current.respond_to?(:detect)
                             current.detect do |model|
                               document_path_matches?(path, model)
                             end
                           end

          if path['relation'].blank?
            return relation_match
          else
            relation_match.send(path['relation'])
          end
        end
      end

      def document_path_matches?(path, object)
        object.class.name == path['type'] && object.id == path['id']
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
