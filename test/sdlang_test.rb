# frozen_string_literal: true

require 'minitest/autorun'
require 'sdlang'
require_relative 'test_helper'

class SDLangTest < Minitest::Test
  def test_website_example
    input = File.read(File.join(__dir__, 'fixtures', 'website_example.sdl'))
    result = SDLang.parse(input)
    assert(result.nodes.all? { |node| node.is_a?(SDLang::Node) })
    assert result.is_a?(SDLang::NodeSet)
    assert_equal 6, result.size
  end

  # caching parse result, as we're going to only read
  def cached_result
    @cached_result ||= begin
      input = File.read(File.join(__dir__, 'fixtures', 'website_example.sdl'))
      SDLang.parse(input)
    end
  end

  def test_find_nodes
    result = cached_result
    titles = result.find_nodes('title')
    assert_equal 1, titles.size
  end

  def test_find_nodes_non_existing
    non_ex = cached_result.find_nodes('non-existing')
    assert_equal [], non_ex
  end

  def test_find_nodes_multiple
    section = cached_result.find_node('contents').children.find_node('section').children
    paragraphs = section.find_nodes('paragraph')
    assert_equal 2, paragraphs.length
  end

  def test_find_node
    title = cached_result.find_node('title')
    assert title.is_a?(SDLang::Node)
    assert_equal "Hello, World", title.value
  end

  def test_find_node_non_existing
    non_ex = cached_result.find_node('non-existing')
    assert_nil non_ex
  end

  def test_find_node_ambiguous
    section = cached_result.find_node('contents').children.find_node('section').children
    assert_raises(SDLang::NodeSet::AmbiguousNodeName) {
      section.find_node('paragraph')
    }
  end
end
