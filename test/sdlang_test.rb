# frozen_string_literal: true

require "minitest/autorun"
require "sdlang"
require_relative "test_helper"

class SDLangTest < Minitest::Test
  def test_website_example
    input = File.read(File.join(__dir__, "fixtures", "website_example.sdl"))
    result = SDLang.parse(input)
    assert result.is_a?(SDLang::Tag)
    assert_equal "", result.name
    assert_equal "", result.namespace
    assert_equal 6, result.children.size
  end
end
