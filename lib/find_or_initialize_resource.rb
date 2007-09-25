module FindOrInitializeResource
  
  class << self
    def filter_actions
      @filter_actions ||= %w(show edit update destroy create new)
    end
    
    def filter_actions=(actions)
      @filter_actions = actions
    end
  end
  
  module ControllerExtensions
  
    def find_or_initialize_resource(options = {})
      FindOrInitializeResource::Builder.new(options, self).build
    end
  
  end
  
  class Builder
    
    OPTIONS = [:model, :context, :also_filter]
    
    attr_reader :options, :controller
    
    def initialize(options, controller)
      @options, @controller = options, controller
    end
    
    def build
      unless finder_exists?
        controller.class_eval <<-STR
          def #{finder_name}
            if params[:id]
              @#{model_name} = #{context}.find(#{parameters_for_find})
            else
              @#{model_name} = #{context}.respond_to?(:build) ? #{context}.build : #{context}.new
            end
          end
          
          private :#{finder_name}
        STR
      end
      
      controller.before_filter finder_name.to_sym, :only => filter_actions
    end
    
    private
    
    def model_name
      @model_name ||= options[:model] && options[:model].underscore || controller.controller_name.singularize
    end

    def context
      options[:context] || model_name.classify
    end
    
    def finder_name
      @finder_name ||= "find_or_initialize_#{model_name}"
    end
    
    def options_for_find
      returning options.clone do |options|
        OPTIONS.each { |opt| options.delete opt }
      end
    end
    
    def finder_exists?
      controller.private_method_defined?(finder_name) || controller.method_defined?(finder_name)
    end
    
    def parameters_for_find
      returning "params[:id]" do |params|
        params << ", #{options_for_find.inspect}" unless options_for_find.empty?
      end
    end
    
    def filter_actions
      FindOrInitializeResource.filter_actions + Array(options[:also_filter])
    end
    
  end
  
end
