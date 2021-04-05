module SDLang
  # Represents a set of nodes in a low-level API
  class NodeSet
    # Thrown when a function expecting one node with a given name to exist
    # but more that one is present, for example #find_node
    AmbiguousNodeName = Class.new(StandardError)

    attr_reader :nodes

    def initialize(nodes = [])
      @nodes = nodes
    end

    def size
      nodes.size
    end

    def find_nodes(name)
      nodes.select { |node| node.name == name.to_s }
    end

    def find_node(name)
      candidates = find_nodes(name)

      raise AmbiguousNodeName.new(name) if candidates.length > 1

      candidates.first
    end
  end
end
