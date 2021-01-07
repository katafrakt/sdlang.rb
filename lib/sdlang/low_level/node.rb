module SDLang
  # Represents a single node in a low-level API
  class Node
    # An exception thrown when you are trying to extract value from a multi-value node
    MultipleValues = Class.new(StandardError)

    def initialize(attributes: {}, children: NodeSet.new, namespace: '', values: [])
      @attributes = attributes
      @children = children
      @namespace = namespace
      @values = values
    end

    def attribute(name)
      attributes.fetch(name)
    end

    def values
      @values
    end

    # TODO: handle no value nodes
    def value
      raise MultipleValues if values.length > 1

      values.first
    end

    private

    attr_reader :attributes, :chldren, :namespace
  end
end
