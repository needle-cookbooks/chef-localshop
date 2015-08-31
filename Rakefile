require 'foodcritic'
require 'rspec/core/rake_task'
require 'rubocop/rake_task'

# Modify top level class for nicer output
class String
  def green
    "\033[32m#{self}\033[0m"
  end

  def bold
    "\033[1m#{self}\033[0m"
  end
end

task :rubocop_pass do
  puts '** Rubocop passed! **'.green.bold
end

task :food_pass do
  puts '** FoodCritic passed! **'.green.bold
end

task :spec_pass do
  puts '** ChefSpec passed! **'.green.bold
end

desc 'Install Gem dependencies'
task :bundle do
  File.delete('Gemfile.lock') if File.exist?(File.expand_path('Gemfile.lock'))
  exit(1) unless system('bundle install') || File.exist?(File.expand_path('Gemfile.lock'))
  puts '** Installed gems with Bundle! **'.green.bold
end

desc 'Install Berkshelf dependencies'
task :berks do
  File.delete('Berksfile.lock') if File.exist?(File.expand_path('Berksfile.lock'))
  exit(1) unless system('berks install') || File.exist?(File.expand_path('Berksfile.lock'))
  puts '** Installed cookbook deps with Berkshelf! **'.green.bold
end

desc 'Install all dependencies'
task deps: [:bundle, :berks]

desc 'Run RuboCop checks'
task :rubocop do
  puts '** Rubocop passed! **'.green.bold unless RuboCop::RakeTask.new
end

desc 'Run FoodCritic lint checks'
task :foodcritic do
  puts '** FoodCritic passed! **'.green.bold unless FoodCritic::Rake::LintTask.new do |t|
    t.options = { fail_tags: ['any'] }
  end
end

desc 'Run ChefSpec examples'
task :spec do
  puts '** ChefSpec passed! **'.green.bold unless RSpec::Core::RakeTask.new
end

desc 'Run all tests'
task test: [:rubocop, :rubocop_pass, :foodcritic, :food_pass, :spec, :spec_pass]

desc 'Travis CI test task'
task ci: [:berks, :test]

desc 'Default task, installs all deps and runs all tests'
task default: [:deps, :test]

desc 'Alias for FoodCritic task'
task lint: [:foodcritic, :food_pass]
