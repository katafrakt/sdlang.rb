require 'parslet'
require 'sdlang/ast'

module SDLang
  class Transform < Parslet::Transform
    # simple things
    rule(integer: simple(:integer)) { SDLang::AST::Integer.new(integer) }
    rule(string: simple(:string)) { SDLang::AST::String.new(string) }
    rule(true: simple(:true)) { SDLang::AST::Boolean.new(true) }
    rule(false: simple(:false)) { SDLang::AST::Boolean.new(false) }

    # regular tag
    rule(
      identifier: simple(:name),
      namespace: simple(:namespace),
      values: sequence(:values),
      attributes: sequence(:attributes),
      children: subtree(:children)
    ) { SDLang::AST::Tag.new(name, namespace, values, attributes, children) }

    # anonymous tag
    rule(
      values: sequence(:values),
      attributes: sequence(:attributes),
      children: subtree(:children)
    ) { SDLang::AST::Tag.new('', nil, values, attributes, children) }

    rule(
      identifier: simple(:name),
      value: simple(:value)
    ) { SDLang::AST::Attribute.new(name, value) }
  end
end
