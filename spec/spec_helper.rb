require 'rspec/core'
require 'autotest/autodiff_rspec2'

Dir['./spec/support/**/*.rb'].map {|f| require f}

RSpec.configure do |c|
  c.alias_it_should_behave_like_to 'it_handles'
end
