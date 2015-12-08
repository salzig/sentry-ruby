require 'rake'
require 'raven'
require 'rubygems/package_task'

gemspec = Gem::Specification.load(Dir['*.gemspec'].first)

Gem::PackageTask.new(gemspec).define

begin
  require 'rubygems'
  require 'rspec/core/rake_task'

  if RUBY_VERSION > '1.8.7'
    require 'rubocop/rake_task'
    RuboCop::RakeTask.new(:rubocop)
  end

  RSpec::Core::RakeTask.new(:spec) do |spec|
    spec.pattern = 'spec/**/*_spec.rb'
  end

rescue LoadError
  task :spec do
    abort "Rspec is not available. bundle install to run unit tests"
  end
end

if RUBY_VERSION > '1.8.7'
  task :default => [:rubocop, :spec]
else
  task :default => :spec
end
