# frozen_string_literal: true

require "rspec/core"
require "rspec/expectations"

require_relative "../rspec_plugin/reporter"
require_relative "../rspec_plugin/trace"
require_relative "../test_links_plugin/formatter"

Buildkite::TestCollector.uploader = Buildkite::TestCollector::Uploader

module ParallelRSpec
  OldClient = Client

  class NewClient < OldClient
    def initialize(...)
      super
      @bk_reporter = Buildkite::TestCollector::RSpecPlugin::Reporter.new(STDOUT)
    end

    def example_passed(ex)
      notify_bk(ex)
      super
    end

    def example_failed(ex)
      notify_bk(ex)
      super
    end

    def example_pending(ex)
      notify_bk(ex)
      super
    end

    def result(...)
      @bk_reporter.dump_summary(nil)
      super
    end

    def notify_bk(example)
      notification = RSpec::Core::Notifications::ExampleNotification.for(example)
      @bk_reporter.handle_example(notification)
    end
  end

  remove_const(:Client)
  const_set(:Client, NewClient)
end

RSpec.configure do |config|
  config.before(:suite) do
    config.add_formatter Buildkite::TestCollector::TestLinksPlugin::Formatter
  end

  config.around(:each) do |example|
    tracer = Buildkite::TestCollector::Tracer.new(
      min_duration: Buildkite::TestCollector.trace_min_duration,
    )

    # The _buildkite prefix here is added as a safeguard against name collisions
    # as we are in the main thread
    Thread.current[:_buildkite_tracer] = tracer
    # It's important to use begin/ensure here, because otherwise if other hooks fail,
    # the cleanup code won't run, meaning we will miss some data.
    #
    # Having said that, this behavior isn't documented by RSpec.
    begin
      example.run
    ensure
      Thread.current[:_buildkite_tracer] = nil

      tracer.finalize

      trace = Buildkite::TestCollector::RSpecPlugin::Trace.new(example, history: tracer.history)
      Buildkite::TestCollector.uploader.traces[example.id] = trace
    end
  end
end

Buildkite::TestCollector.enable_tracing!
