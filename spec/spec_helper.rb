require File.join(File.dirname(__FILE__), '..', 'shomei.rb')

require 'rack/test'

set :environment, :test

RSpec.configure do |conf|
  conf.include Rack::Test::Methods
end
