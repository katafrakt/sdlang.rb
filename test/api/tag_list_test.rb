require "minitest/autorun"
require "sdlang"
require_relative "../test_helper"

describe SDLang::TagList do
  def website_example
    @website_example ||= File.read(File.join(__dir__, "../fixtures", "website_example.sdl"))
  end

  def website_tags
    @website_tags ||= SDLang.parse(website_example)
  end

  def filesystem_tags
    @website_tags ||= SDLang.parse(File.read(File.join(__dir__, "../fixtures", "filesystem_example.sdl")))
  end

  describe ".from_ast" do
    it "parses AST" do
      parser = SDLang::Parser.new
      transform = SDLang::Transform.new
      parsed = parser.parse(website_example)
      ast = transform.apply(parsed)
      tags = ast.map(&:eval)

      assert SDLang::TagList.from_ast(tags).is_a?(SDLang::TagList)
    end
  end

  describe "#size" do
    it { assert_equal 6, website_tags.size }
  end

  describe "#find" do
    it "finds by string name" do
      tag = filesystem_tags.find("directory")
      _(tag).must_be_kind_of(SDLang::Tag)
    end

    it "finds by symbol name" do
      tag = filesystem_tags.find(:directory)
      _(tag).must_be_kind_of(SDLang::Tag)
    end

    it "raises for multiple tags" do
      _(-> {
        filesystem_tags.find("file")
      }).must_raise(SDLang::TagList::AmbiguousNodeName)
    end

    it "returns nil for non-existing tag" do
      tag = filesystem_tags.find("i_dont_exist")
      _(tag).must_be_nil
    end
  end

  describe "#find_all" do
    it "returns array when only one tag present" do
      tags = filesystem_tags.find_all("directory")
      _(tags.length).must_equal(1)
      _(tags.first).must_be_kind_of(SDLang::Tag)
    end

    it "returns array when multiple tags present" do
      tags = filesystem_tags.find_all("file")
      _(tags.length).must_equal(2)
    end

    it "returns empty array when no tags present" do
      tags = filesystem_tags.find_all("i_dont_exist")
      _(tags).must_equal([])
    end

    it "finds by symbol" do
      tags = filesystem_tags.find_all(:file)
      _(tags.length).must_equal(2)
    end
  end
end
