# encoding: UTF-8

# Require everything directly under lib/
Dir[File.join(File.dirname(__FILE__), "../lib/*")].each do |lib_file|
  require lib_file
end

require "minitest/autorun"
require "minitest/reporters"

class CustomReporter < Minitest::Reporters::DefaultReporter
  def before_suite(suite)
  end

  def on_record(result)
    super

    test_path = result.klass.split("::")
    test_path << result.name.gsub(/^test_\d+_/, '')
    print " "
    color = if result.skipped?
      method(:yellow)
    elsif result.failure
      method(:red)
    else
      :itself
    end
    puts test_path.map(&color).join(blue(" · "))
  end

  def record_pass(record)
    green("✔︎")
  end

  def record_skip(record)
    yellow("S")
  end

  def record_failure(record)
    red("✖︎")
  end
end

Minitest::Reporters.use! CustomReporter.new

module Minitest::Assertions
  def assert_invalid_transition
    assert_raises AASM::InvalidTransition do
      yield
    end
  end
end
