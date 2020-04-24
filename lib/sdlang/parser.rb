require 'parslet'

module SDLang
  class Parser < Parslet::Parser
    root(:definitions)

    # tokens
    rule(:dbl_quot) { str('"') }
    rule(:semicolon) { str(';') }

    # whitespace
    rule(:space)  { match('\s').repeat(1) }
    rule(:space?) { space.maybe }
    rule(:newl)   { match('\n') }

    # actual language parts
    rule(:empty_line)         { newl }
    rule(:string)             { double_quoted_string }
    rule(:integer)            { match('[0-9]').repeat(1).as(:int) >> space? }
    rule(:value)              { string | integer }
    rule(:tag_def)            { space? >> identifier.as(:tag_name) >> space? >> value.as(:value) >> space? }
    rule(:expression)         { (space? >> expression_end) | (tag_def >> expression_end) }
    rule(:expression_end)     { space? >> (newl | semicolon).maybe }
    rule(:definitions)        { (empty_line | tag_def).repeat }

    # helper stuff
    rule(:identifier) {
      (match('[a-zA-Z]') >> match('[a-zA-Z0-9_-]').repeat).as(:identifier) >> space?
    }

    rule(:double_quoted_string) {
      str('"') >> (
        str('\\') >> any |
        str('"').absent? >> any
      ).repeat.as(:string) >> str('"') >> space?
    }
  end
end
