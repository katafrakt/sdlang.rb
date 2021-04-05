require 'minitest/autorun'
require 'sdlang'
require_relative '../test_helper'

describe SDLang::NodeSet do
  def cached_result
    @cached_result ||= begin
      input = File.read(File.join(__dir__, '../fixtures', 'website_example.sdl'))
      SDLang.parse(input)
    end
  end

  describe '#find_nodes' do
    it 'works for a single node' do
      _(cached_result.find_nodes('title').length).must_equal(1)
    end

    it 'works for multiple nodes' do
      section = cached_result.find_node('contents').children.find_node('section').children
      paragraphs = section.find_nodes('paragraph')
      _(paragraphs.length).must_equal(2)
    end

    it 'returns empty array for non-existing children' do
      _(cached_result.find_nodes('i-am-not-here')).must_equal([])
    end
  end

  describe '#find_node' do
    it 'works for a single node' do
      _(cached_result.find_node('title')).must_be_kind_of(SDLang::Node)
      _(cached_result.find_node('title').value).must_equal('Hello, World')
    end

    it 'returns nil for non-existing node' do
      _(cached_result.find_node('non-existing')).must_be_nil
    end

    it 'raises exception when mode than one node matches' do
      section = cached_result.find_node('contents').children.find_node('section').children
      _(-> { section.find_node('paragraph') }).must_raise(SDLang::NodeSet::AmbiguousNodeName)
    end
  end
end
