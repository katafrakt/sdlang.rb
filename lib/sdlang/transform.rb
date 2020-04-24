require 'parslet'
require 'sdlang/ast'

module SDLang
  class Transform < Parslet::Transform
    # simple things
    rule(int: simple(:int)) { SDLang::AST::IntLit.new(int) }
    rule(string: simple(:string)) { SDLang::AST::StringLit.new(string) }

    # tag with only name and value
    rule(
      tag_name: { identifier: simple(:name) },
      value: simple(:value)
    ) { SDLang::AST::Tag.new(name, value) }
  end
end
