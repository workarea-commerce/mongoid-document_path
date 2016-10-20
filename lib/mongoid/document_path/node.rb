module Mongoid
  module DocumentPath
    class Node
      include Mongoid::Document

      field :type, type: String
      field :document_id, type: String
      field :relation, type: String

      def matches?(document)
        document.class.name == type && document.id.to_s == document_id
      end

      def terminal?
        relation.blank?
      end
    end
  end
end
