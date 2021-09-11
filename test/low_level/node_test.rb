require "minitest/autorun"
require "sdlang"
require_relative "../test_helper"

describe SDLang::Node do
  def cached_result
    @cached_result ||= begin
      input = File.read(File.join(__dir__, "../fixtures", "website_example.sdl"))
      SDLang.parse(input)
    end
  end

  def node(name)
    cached_result.nodes.detect { |node| node.name == name.to_s }
  end

  describe "#values" do
    it "works with single value" do
      _(node("title").values).must_equal(["Hello, World"])
    end

    it "works with multiple values" do
      _(node("bookmarks").values).must_equal([12, 15, 188, 1234])
    end

    it "returns empty array when no values are present" do
      _(node("contents").values).must_equal([])
    end
  end

  describe "#value" do
    it "works with string" do
      _(node("title").value).must_equal("Hello, World")
    end

    it "raises exception with multiple values" do
      _(-> { node("bookmarks").value }).must_raise(SDLang::Node::MultipleValues)
    end

    it "work when node has attributes" do
      _(node("author").value).must_equal("Peter Parker")
    end

    it "returns nil for nodes without value" do
      _(node("contents").value).must_be_nil
    end
  end

  describe "#attribute" do
    it "returns string" do
      _(node("author").attribute("email")).must_equal("peter@example.org")
    end

    it "returns boolean" do
      _(node("author").attribute("active")).must_equal(true)
    end

    it "returns nil for non-existent attribute" do
      _(node("author").attribute("nationality")).must_be_nil
    end

    it "returns nil when node has no attributes" do
      _(node("title").attribute("subtitle")).must_be_nil
    end

    it "works with symbol argument" do
      _(node("author").attribute(:email)).must_equal("peter@example.org")
    end
  end
end
