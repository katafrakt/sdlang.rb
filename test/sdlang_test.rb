# frozen_string_literal: true

require "minitest/autorun"
require "sdlang"
require_relative "test_helper"

class SDLangTest < Minitest::Test
  def test_website_example
    input = File.read(File.join(__dir__, "fixtures", "website_example.sdl"))
    result = SDLang.parse(input)
    assert(result.nodes.all? { |node| node.is_a?(SDLang::Node) })
    assert result.is_a?(SDLang::NodeSet)
    assert_equal 6, result.size
  end
end
