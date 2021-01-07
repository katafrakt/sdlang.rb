# frozen_string_literal: true

require 'sdlang/low_level/node'
require 'sdlang/low_level/node_set'

module SDLang
  module AstToNode
    def self.call(ast)
      SDLang::Node.new(
        attributes: SDLang::NodeSet.new(map_attributes(ast.attributes)),
        namespace: ast.namespace,
        values: ast.values,
        children: SDLang::NodeSet.new(ast.children ? ast.children.map { |child| call(child) } : [])
      )
    end

    def self.map_attributes(attrs)
      return {} if attrs.nil? || attrs.empty?

      attrs.map { |attr| [attr.name.to_sym, attr.value] }.to_h
    end
  end
end
