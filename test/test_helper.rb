require 'rubygems'
%w(mocha rails).each { |g| gem g }
%w(test/unit action_controller mocha).each { |r| require r }

require File.join(File.dirname(__FILE__), '..', 'init')

Post = Comment = Class.new
