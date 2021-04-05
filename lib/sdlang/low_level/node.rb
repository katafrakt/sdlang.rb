module SDLang
  # Represents a single node in a low-level API
  class Node
    # An exception thrown when you are trying to extract value from a multi-value node
    MultipleValues = Class.new(StandardError)

    attr_reader :children, :name

    def initialize(name:, attributes: {}, children: NodeSet.new, namespace: '', values: [])
      @name = name
      @attributes = attributes
      @children = children
      @namespace = namespace
      @values = values
    end

    def attribute(name)
      attributes[name.to_s]
    end

    def values
      @values
    end

    def value
      raise MultipleValues if values.length > 1

      values.first
    end

    private

    attr_reader :attributes, :namespace
  end
end
