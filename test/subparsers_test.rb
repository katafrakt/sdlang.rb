require 'minitest/autorun'
require 'sdlang'
require 'parslet/convenience'
require_relative 'test_helper'

class SubparsersTest < Minitest::Test
  include ExtraAssertions

  def parser
    SDLang::Parser.new
  end

  # strings
  def test_double_quoted_string
    assert_parses(parser.string, '"test"')
  end

  def test_double_quoted_string_with_escape
    assert_parses(parser.string, '"test with \"escaped\""')
  end

  def test_fenced_string
    assert_parses(parser.string, '`test`')
  end

  def test_multiline_fenced_string
    input = "`test\nbest`"
    assert_parses(parser.string, input)
  end

  # comments
  def test_single_line_comment_with_hash
    assert_parses(parser.comment, '# this is a comment')
    assert_parses(parser.comment, "# this is a comment\n")
  end

  def test_single_line_comment_with_two_slashes
    assert_parses(parser.comment, '// this is a comment')
    assert_parses(parser.comment, "// this is a comment\n")
  end

  def test_single_line_comment_with_two_dashes
    assert_parses(parser.comment, '-- this is a comment')
    assert_parses(parser.comment, "-- this is a comment\n")
  end

  def test_multi_comment_simple
    assert_parses(parser.comment, '/* // abc */')
  end

  def test_multi_comment_nested
    skip(parser.comment, '/* abc /* */ agf */')
  end

  # bool
  def test_bool
    orig_parser = parser
    parser = orig_parser.boolean
    assert_parses(parser, 'true')
    assert_parses(parser, 'on')
    assert_parses(parser, 'off')
    assert_parses(parser, 'false')
  end

  # date
  def test_date
    assert_parses(parser.date, '2017/10/11')
  end

  # null
  def test_null
    assert_parses(parser.null, 'null')
  end

  # values
  def test_null_value
    assert_parses(parser.value, 'null')
  end

  def test_bool_value
    assert_parses(parser.value, 'off')
  end

  def test_string_value
    assert_parses(parser.value, '"test \"string\""')
  end

  # ident
  def test_alpha_ident
    assert_parses(parser.ident, 'abcd')
  end

  def test_alphanum_ident
    assert_parses(parser.ident, 'a123')
  end

  # namespace
  def test_namespace
    assert_parses(parser.namespace, 'test:')
  end

  # tag
  def test_nameless_tag
    assert_parses(parser.tag, '"test string"')
  end

  def test_simple_tag
    assert_parses(parser.tag, 'sdlang true')
    assert_parses(parser.tag, 'lines 2')
  end

  def test_simple_tag_with_namespace
    assert_parses(parser.tag, 'test:name "simple_tag_with_namespace"')
  end

  def test_tag_with_multiple_values
    assert_parses(parser.tag, 'years 1996 1998 2001 2028')
  end

  # tags
  def test_tags_empty_doc
    assert_parses(parser.tags, '')
    assert_parses(parser.tags, "\n")
  end

  def test_tags_single_tag_with_newline
    assert_parses(parser.tags, "lines 2\n")
    assert_parses(parser.tags, "revision 100\n")
  end

  def test_tags_two_simple
    assert_parses(parser.tags, "version 1\nrevision 100\n")
    assert_parses(parser.tags, "version 1\nrevision 100")
  end
end
