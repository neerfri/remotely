require "remotely"
require 'webmock/rspec'
require "yajl"
WebMock.disable_net_connect!
require "support/webmock"
require "support/test_classes"

RSpec.configure do |c|
  c.before do
    WebmockHelpers.stub!
  end

  def to_json(obj)
    Yajl::Encoder.encode(obj)
  end
end
