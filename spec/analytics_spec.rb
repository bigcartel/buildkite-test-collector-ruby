# frozen_string_literal: true

RSpec.describe RSpec::Buildkite::Analytics do
  it "can configure api_token, url, and filename" do
    analytics = RSpec::Buildkite::Analytics
    ENV["BUILDKITE_ANALYTICS_TOKEN"] = "MyToken"

    analytics.configure

    expect(analytics.api_token).to eq "MyToken"
    expect(analytics.url).to eq "https://analytics-api.buildkite.com/v1/uploads"
    expect(analytics.filename).to be nil
  end
end