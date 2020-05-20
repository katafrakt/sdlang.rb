require 'minitest/autorun'
require 'sdlang'
require_relative 'test_helper'

class TransformTest < Minitest::Test
  def transform(string)
    parser = SDLang::Parser.new
    transform = SDLang::Transform.new
    parsed = parser.parse(string)
    ast = transform.apply(parsed)
    ast.map(&:eval)
  end

  def test_integer
    result = transform('version 2')
    tag = result.first
    assert_equal([2], tag.values)
  end

  def test_string
    result = transform('sdlang "yes"')
    tag = result.first
    assert_equal(['yes'], tag.values)
  end
end
