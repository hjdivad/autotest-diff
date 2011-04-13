require 'autotest/rails_rspec2'
require 'autotest/auto_diff'

class Autotest::AutodiffRailsRspec2 < Autotest::RailsRspec2
  include ::Autotest::AutoDiff
end
