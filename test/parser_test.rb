require 'minitest/autorun'
require 'sdlang'
require 'parslet/convenience'

class ParserTest < Minitest::Test
  def parse_sdl(string)
    parser = SDLang::Parser.new
    parser.parse_with_debug(string)
  end

  def test_empty_string
    result = parse_sdl('')
    assert_equal(0, result.length)
  end

  def test_simple_tag_string_value
    result = parse_sdl('sdlang "yes"')
    assert_equal(1, result.length)

    tag = result.first
    tag_name = tag[:tag_name]
    value = tag[:value]

    assert_equal('sdlang', tag_name[:identifier])
    assert_equal('yes', value[:string])
  end

  def test_simple_tag_integer_value
    result = parse_sdl('version 2')
    assert_equal(1, result.length)

    tag = result.first
    tag_name = tag[:tag_name]
    value = tag[:value]

    assert_equal('version', tag_name[:identifier])
    assert_equal('2', value[:int])
  end

  def test_two_tags
    input = %Q{
          sdlang "yes"
          lines 2
    }
    result = parse_sdl(input)
    assert_equal(2, result.length)

    assert_equal('sdlang', result.dig(0, :tag_name, :identifier))
    assert_equal('lines', result.dig(1, :tag_name, :identifier))
    assert_equal('2', result.dig(1, :value, :int))
  end
end
