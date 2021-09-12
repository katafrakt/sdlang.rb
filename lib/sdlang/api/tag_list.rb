# frozen_string_literal: true

require_relative "tag"

module SDLang
  class TagList
    # API: private
    #
    # Converts internal AST representation to TagList object
    def self.from_ast(ast)
      new(ast.map(&SDLang::Tag.method(:from_ast)))
    end

    # Thrown when a function expecting one node with a given name to exist
    # encounters more that one
    AmbiguousNodeName = Class.new(StandardError)

    def initialize(tags)
      @tags = tags
    end

    # Returns a number of child tags
    def size
      @tags.length
    end

    def find(name)
      candidates = find_all(name)
      raise AmbiguousNodeName.new(name) if candidates.length > 1

      candidates.first
    end

    def find_all(name)
      # FIXME: handle namespace correctly
      @tags.select { |tag| tag.name == name.to_s }
    end
  end
end
