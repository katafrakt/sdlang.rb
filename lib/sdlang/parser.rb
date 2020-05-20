require 'parslet'

module SDLang
  # heavily inspired by sdlang for Rust
  class Parser < Parslet::Parser
    # tokens
    rule(:dbl_quot) { str('"') }
    rule(:semicolon) { str(';') }

    rule(:comment) {
      str('/*') >> (str('*/').absent? >> any).repeat >> str('*/') |
        (str('//') | str('#') | str('--')) >> (str("\n").absent? >> any).repeat >> str("\n").maybe
    }
    rule(:ws) { (match('\s') | comment).repeat }

    # string
    rule(:string_special) { match['\0\t\n\r"\\\\'] }
    rule(:escaped_special) { str('\\') >> match['0tnr"\\\\'] }
    rule(:dbl_quoted_string) { str('"') >> (escaped_special | string_special.absent? >> any).repeat.as(:string) >> str('"') }
    rule(:fenced_string) { str('`') >> (str('`').absent? >> any).repeat.as(:string) >> str('`') }
    rule(:string) { dbl_quoted_string | fenced_string }

    # integer
    rule(:digit) { match('[0-9]') }
    rule(:integer) {
      (
        str('-').maybe >> (
          str('0') | (match('[1-9]') >> digit.repeat))
      ).as(:integer)
    }

    # boolean
    rule(:bool_true) { str('true') | str('on') }
    rule(:bool_false) { str('false') | str('off') }
    rule(:boolean) { bool_true.as(:true) | bool_false.as(:false) }

    rule(:null) { str('null') }

    rule(:value) {
      string | boolean | null | integer
    }

    rule(:ident) {
      (match('[0-9$.-]').absent? >> match('\w').repeat(1))
        .as(:identifier)
    }
    rule(:attribute) { ident >> str('=') >> value }
    rule(:namespace) { ident.as(:namespace) >> str(':') }
    rule(:tag) {
      (value | (namespace.maybe >> ident)) >> ws >>
        (value >> ws).repeat.as(:values) >>
        (attribute >> ws).repeat.as(:attributes) >>
        (str('{') >> tags >> str('}')).maybe.as(:body)
    }
    rule(:eof) { any.absent? }
    rule(:tag_separator) { semicolon | str('\n') }
    rule(:tags) {
      ws >> (tag >> tag_separator.maybe >> ws).repeat
    }

    root(:tags)
  end
end
