require 'autotest/rspec2'
require 'autotest/auto_diff'
require 'active_support/concern'
require 'fileutils'

class Autotest::AutodiffRspec2 < Autotest::Rspec2
  include ::Autotest::AutoDiff
end

