require 'spec_helper'

RSpec.describe Raven::Client do
  let(:configuration) do
    Raven::Configuration.new.tap do |config|
      config.server = 'http://12345:67890@sentry.localdomain/sentry/42'
    end
  end
  let(:client) { Raven::Client.new(configuration) }

  before do
    @fake_time = Time.now
    allow(Time).to receive(:now).and_return @fake_time
  end

  it "generates an auth header" do
    expect(client.send(:generate_auth_header)).to eq(
      "Sentry sentry_version=5, sentry_client=raven-ruby/#{Raven::VERSION}, sentry_timestamp=#{@fake_time.to_i}, " \
      "sentry_key=12345, sentry_secret=67890"
    )
  end

  it "generates an auth header without a secret (Sentry 9)" do
    client.configuration.server = "https://66260460f09b5940498e24bb7ce093a0@sentry.io/42"

    expect(client.send(:generate_auth_header)).to eq(
      "Sentry sentry_version=5, sentry_client=raven-ruby/#{Raven::VERSION}, sentry_timestamp=#{@fake_time.to_i}, " \
      "sentry_key=66260460f09b5940498e24bb7ce093a0"
    )
  end

  describe "#transport" do
    context "when scheme is not set" do
      it "returns HTTP transport object" do
        expect(client.transport).to be_a(Raven::Transports::HTTP)
      end
    end

    context "when scheme is http" do
      before do
        client.configuration.scheme = "http"
      end

      it "returns HTTP transport object" do
        expect(client.transport).to be_a(Raven::Transports::HTTP)
      end
    end

    context "when scheme is https" do
      before do
        client.configuration.scheme = "https"
      end

      it "returns HTTP transport object" do
        expect(client.transport).to be_a(Raven::Transports::HTTP)
      end
    end

    context "when scheme is dummy" do
      before do
        client.configuration.scheme = "dummy"
      end

      it "returns Dummy transport object" do
        expect(client.transport).to be_a(Raven::Transports::Dummy)
      end
    end

    context "when scheme is stdout" do
      before do
        client.configuration.scheme = "stdout"
      end

      it "returns Stdout transport object" do
        expect(client.transport).to be_a(Raven::Transports::Stdout)
      end
    end
  end
end
