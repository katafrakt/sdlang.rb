# frozen_string_literal: true

require 'minitest/autorun'
require 'sdlang'
require_relative 'test_helper'

class TransformTest < Minitest::Test
  EMPTY_NAMESPACE = ''

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

  def test_website_example
    input = File.read(File.join(__dir__, 'fixtures', 'website_example.sdl'))
    result = transform(input)

    title = result[0]
    assert_equal('title', title.name)
    assert_equal(EMPTY_NAMESPACE, title.namespace)
    assert_equal('Hello, World', title.values.first)

    bookmarks = result[1]
    assert_equal(4, bookmarks.values.length)
    assert_equal(188, bookmarks.values[2])

    author = result[2]
    assert_equal('Peter Parker', author.values.first)
    assert_equal('email', author.attributes.first.name)
    assert_equal('peter@example.org', author.attributes.first.value)
    assert_equal(true, author.attributes.last.value)

    contents = result[3]
    refute_nil(contents.children)
    assert_equal(1, contents.children.length)

    anonymous = result[4]
    assert_equal('', anonymous.name)
  end
end
