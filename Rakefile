require 'yaml'
require 'fileutils'

require 'rubygems'
require 'project/tasks'
require 'rake'

Dir[ 'lib/tasks/**/*' ].each{ |l| require l }


begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "autotest-diff"
    gem.summary = %Q{Autotest style that only runs rspec examples within a spec that have changed.}
    gem.description = %Q{
      autotest-diff is an autotest style for rspec2 or rspec2 rails that tries
      not to run specs you aren't working on.

      It is obviously most helpful when you have slow-running specs, as is often
      the case when working on a rails app, for instance.

      When autotest decides to run multiple test files, autotest-diff behaves
      just as rspec's style.  When running only a single file, autotest-diff
      compares the current file against a cached copy.  
      
      If there is no cached copy, all examples are run.
      
      If there is a cached copy, only the examples that are modified are run.
      This is done by passing --line_number flags to rspec.

      autotest-diff has a very simple implementation, and depends on diff and
      sed being in your $PATH.  autotest-diff is not expected to work on windows.
    }
    gem.email = "autotest-diff@hjdivad.com"
    gem.homepage = "http://github.com/hjdivad/autotest-diff"
    gem.authors = ["David J. Hamilton"]

    if File.exists? 'Gemfile'
      require 'bundler'
      bundler = Bundler.load
      bundler.dependencies_for( :runtime ).each do |dep|
        gem.add_dependency              dep.name, dep.requirement.to_s
      end
      bundler.dependencies_for( :development ).each do |dep|
        gem.add_development_dependency  dep.name, dep.requirement.to_s
      end
    end
    # gem is a Gem::Specification... see http://www.rubygems.org/read/chapter/20 for additional settings
  end
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: gem install jeweler"
end


desc "Run all specs."
task :spec do
  # Jeweler messes up specs by polluting ENV
  ENV.keys.grep( /git/i ).each{|k| ENV.delete k }
  sh "rspec spec/autotest spec/integration"
end


begin
  require 'yard'
  YARD::Rake::YardocTask.new
rescue LoadError
  desc "Try (and fail) to run yardoc to get an error message."
  task :yard do
    abort "YARD is not available. In order to run yardoc, you must: sudo gem install yard"
  end
end
