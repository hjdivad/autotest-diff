
source :gemcutter

group :runtime do
  # TODO 2: drop to rspec-core version when patch accepted
  gem 'rspec-core',
    :git => 'git@github.com:hjdivad/rspec-core.git',
    :branch => 'specify-multiple-examples-by-line-number'
  gem 'activesupport'
end

group :development do
  gem 'autotest'
  gem 'rspec'
  gem 'project'
  gem 'jeweler'
  gem 'yard'

  platforms :mri_19 do
    gem 'ruby-debug19'
  end
end


# vim:ft=ruby:
