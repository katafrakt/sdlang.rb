require "minitest/autorun"
require "sdlang"
require "parslet/convenience"
require_relative "test_helper"

class ParserTest < Minitest::Test
  def parse_sdl(string)
    parser = SDLang::Parser.new
    parser.parse_with_debug(string)
  end

  def test_empty_string
    result = parse_sdl("")
    assert_equal(0, result.length)
  end

  def test_simple_tag_string_value
    result = parse_sdl('sdlang "yes"')
    assert_equal(1, result.length)

    tag = result.first
    tag_name = tag[:identifier]
    value = tag[:values].first

    assert_equal("sdlang", tag_name)
    assert_equal("yes", value[:string].to_s)
  end

  def test_simple_tag_integer_value
    result = parse_sdl("version 2")
    assert_equal(1, result.length)

    tag = result.first
    tag_name = tag[:identifier]
    value = tag[:values].first

    assert_equal("version", tag_name)
    assert_equal("2", value[:integer].to_s)
  end

  def test_two_tags
    input = %(
          sdlang "yes"
          lines 2
    )
    result = parse_sdl(input)
    assert_equal(2, result.length)

    assert_equal("sdlang", result.dig(0, :identifier))
    assert_equal("lines", result.dig(1, :identifier))
    assert_equal("2", result.dig(1, :values, 0, :integer).to_s)
  end

  def test_matrix
    input = %(
          matrix {
            1 2 3
            -1 "a" 0
          }
          lines 2
    )
    result = parse_sdl(input)
    assert_equal(2, result.length)

    assert_equal("matrix", result.dig(0, :identifier))
    assert_equal("lines", result.dig(1, :identifier))

    matrix = result[0]
    assert_equal(2, matrix[:children].length)
    assert_equal([3, 3], matrix[:children].map { |c| c[:values].length })
  end

  def test_list
    input = "years 1992 1998 2001 2012"
    result = parse_sdl(input)

    assert_equal(1, result.length)

    list = result.first

    assert_equal("years", list[:identifier])
    assert_equal(4, list[:values].length)

    assert_equal(
      ["1992", "1998", "2001", "2012"],
      list[:values].map { |v| v[:integer] }
    )
  end

  def test_multiple_lists
    input = %(
      dow "Tue" "Fri"
      rooms 134 "134a" "500"
    )

    result = parse_sdl(input)

    assert_equal(2, result.length)
    assert_equal(2, result[0][:values].length)
    assert_equal(3, result[1][:values].length)
  end

  def test_list_followed_by_anonymous_list_separated_by_semicolon
    input = %(
      dow "Tue" "Fri"; 134 "134a" "500"
    )

    result = parse_sdl(input)

    assert_equal(2, result.length)
    assert_equal(2, result[0][:values].length)
    assert_equal(3, result[1][:values].length)
  end

  def test_list_followed_by_anonymous_list_separated_by_newline
    input = %(
      dow "Tue" "Fri"
      134 "134a" "500"
    )

    result = parse_sdl(input)

    assert_equal(2, result.length)
    assert_equal(2, result[0][:values].length)
    assert_equal(3, result[1][:values].length)
  end

  def test_anonymous_lists
    input = %(
      "Tue" "Fri"
      134 "134a" "500"
    )

    result = parse_sdl(input)

    assert_equal(2, result.length)
    assert_equal(2, result[0][:values].length)
    assert_equal(3, result[1][:values].length)
  end
end
