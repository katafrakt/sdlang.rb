# frozen_string_literal: true

module SDLang
  class Tag
    # A helper module handling conversion from AST hash part to a proper Tag object
    module AstToTag
      class << self
        def call(ast)
          SDLang::Tag.new(
            name: ast.name,
            namespace: ast.namespace,
            attributes: map_attributes(ast.attributes),
            values: ast.values,
            children: map_children(ast.children)
          )
        end

        def map_attributes(attrs)
          return {} if attrs.nil? || attrs.empty?
          attrs.map { |attr| [attr.name, attr.value] }.to_h
        end

        def map_children(children)
          return [] unless children
          children.map(&method(:call))
        end
      end
    end

    # An exception thrown when you are trying to extract value from a multi-value node
    MultipleValues = Class.new(StandardError)

    # API: private
    #
    # Converts internal AST representation to a Tag object
    def self.from_ast(ast)
      AstToTag.call(ast)
    end

    attr_reader :children, :name, :values, :attributes

    def initialize(name:, attributes: {}, children: NodeSet.new, namespace: "", values: [])
      @name = name
      @namespace = namespace
      @attributes = attributes
      @children = children
      @values = values
    end

    def value
      raise MultipleValues if values.length > 1

      values.first
    end

    def attribute(name)
      attributes[name.to_s]
    end
  end
end
