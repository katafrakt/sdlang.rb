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

    # date and time
    rule(:datetime) { (date >> ws >> time) }
    rule(:date) {
      (match('[0-9]').repeat(4,4) >> str('/') >>
        match('[0-9]').repeat(2,2) >> str('/') >>
        match('[0-9]').repeat(2,2)).as(:date)
    }
    rule(:msecs) { str('.') >> match('[0-9]').repeat(3,3) }
    rule(:timezone) { str('-') >> match('[a-zA-Z0-9:/-]').repeat(1).as(:timezone) }
    rule(:time) {
      ((match('[0-9]').repeat(1,2) >> str(':') >>
       match('[0-9]').repeat(2,2) >> str(':') >>
       match('[0-9]').repeat(2,2) >> msecs.maybe).as(:time) >> timezone.maybe)
    }

    # boolean
    rule(:bool_true) { str('true') | str('on') }
    rule(:bool_false) { str('false') | str('off') }
    rule(:boolean) { bool_true.as(:true) | bool_false.as(:false) }

    rule(:null) { str('null') }

    rule(:value) {
      datetime | date | time |
      string | boolean | null | integer
    }

    rule(:ident) {
      (match('[0-9$.-]').absent? >> match('\w').repeat(1))
        .as(:identifier)
    }
    rule(:attribute) { ident >> str('=') >> value.as(:value) }
    rule(:namespace) { ident >> str(':') }
    rule(:identifier) { namespace.maybe.as(:namespace) >> ident }
    rule(:regular_tag) {
      identifier >> ws >>
        (value >> ws).repeat.as(:values) >>
        (attribute >> ws).repeat.as(:attributes) >>
        (str('{') >> tags >> str('}')).maybe.as(:children)
    }
    rule(:anonymous_tag) {
        (value >> ws).repeat(1).as(:values) >>
        (attribute >> ws).repeat.as(:attributes) >>
        (str('{') >> tags >> str('}')).maybe.as(:children)
    }
    rule(:tag) { regular_tag | anonymous_tag }
    rule(:tag_separator) { semicolon | str('\n') }
    rule(:tags) {
      ws >> (tag >> tag_separator.maybe >> ws).repeat
    }

    root(:tags)
  end
end
