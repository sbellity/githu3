$:.unshift File.expand_path('..', __FILE__)
$:.unshift File.expand_path('../../lib', __FILE__)
require 'simplecov'
SimpleCov.start
require 'githu3'
require 'rspec'
require 'webmock/rspec'

def fixture_path
  File.expand_path("../fixtures", __FILE__)
end

def fixture(file)
  File.new(fixture_path + '/' + file)
end

def stub_get url, fixture_name, headers={ 'Authorization'=>'token myvalidtoken' }
  stub_request(:get, "https://api.github.com#{url}").
           with(:headers => headers).
           to_return(:status => 200, :body => fixture("#{fixture_name}.json"))
end