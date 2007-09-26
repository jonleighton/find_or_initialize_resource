%w(rubygems spec test/unit action_controller mocha).each { |r| require r }
require File.join(File.dirname(__FILE__), '..', 'init')

Spec::Runner.configure do |config|
  config.mock_with :mocha
end
