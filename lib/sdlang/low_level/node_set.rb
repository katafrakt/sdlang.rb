module SDLang
  # Represents a set of nodes in a low-level API
  class NodeSet
    attr_reader :nodes

    def initialize(nodes = [])
      @nodes = nodes
    end

    def size
      nodes.size
    end
  end
end
