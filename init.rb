require File.join(File.dirname(__FILE__), 'lib', 'find_or_initialize_resource')
ActionController::Base.send :extend, FindOrInitializeResource::ControllerExtensions
