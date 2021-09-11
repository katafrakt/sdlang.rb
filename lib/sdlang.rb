require "sdlang/version"
require "sdlang/parsing/parser"
require "sdlang/parsing/transform"
require "sdlang/low_level/ast_to_node"

module SDLang
  def self.parse(doc)
    parser = SDLang::Parser.new
    transform = SDLang::Transform.new
    parsed = parser.parse(doc)
    ast = transform.apply(parsed)
    tags = ast.map(&:eval)
    SDLang::NodeSet.new(tags.map { |tag| AstToNode.call(tag) })
  end
end
