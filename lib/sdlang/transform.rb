require 'parslet'
require 'sdlang/ast'

module SDLang
  class Transform < Parslet::Transform
    # simple things
    rule(integer: simple(:integer)) { SDLang::AST::IntLit.new(integer) }
    rule(string: simple(:string)) { SDLang::AST::StringLit.new(string) }

    # tag with only name and value
    rule(
      identifier: simple(:name),
      values: sequence(:values),
      attributes: sequence(:attributes),
      body: subtree(:body)
    ) { SDLang::AST::Tag.new(name, values, attributes, body) }
  end
end
