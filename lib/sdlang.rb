require "sdlang/version"
require "sdlang/parsing/parser"
require "sdlang/parsing/transform"
require "sdlang/api/tag_list"

module SDLang
  def self.parse(doc)
    parser = SDLang::Parser.new
    transform = SDLang::Transform.new
    parsed = parser.parse(doc)
    ast = transform.apply(parsed)
    tags = ast.map(&:eval)
    SDLang::TagList.from_ast(tags)
  end
end
