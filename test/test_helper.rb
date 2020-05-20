module ExtraAssertions
  def assert_parses(parser, input)
    begin
      parser.parse(input)
      assert true
    rescue Parslet::ParseFailed => ex
      trace = ex.parse_failure_cause.ascii_tree
      assert false, trace
    end
  end
end

require 'minitest/reporters'
require 'pry'
Minitest::Reporters.use! Minitest::Reporters::DefaultReporter.new
