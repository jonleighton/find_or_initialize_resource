module FindOrInitializeResource
  class Builder
    
    OPTIONS = [:model, :context, :also_filter, :features, :param_id, :only, :resource]
    
    attr_reader :options, :controller
    
    def initialize(controller, options = {})
      options[:features] ||= [ :find, :initialize ]
      @options, @controller = options, controller
    end
    
    def build
      build_foir if finding? && initializing?
      build_finder if finding? && !finder_exists?
      build_initializer if initializing? && !initializer_exists?
      controller.before_filter filter_name.to_sym, :only => filter_actions
    end
    
    def resource_name
      (options[:resource] || controller_resource_name).to_s
    end

    def context
      (options[:context] || resource_name.classify).to_s
    end
    
    def param_id
      if options[:param_id]
        options[:param_id]
      elsif resource_name != controller_resource_name
        "#{resource_name}_id".to_sym
      else
        :id
      end
    end
    
    def foir_name
      "find_or_initialize_#{resource_name}"
    end
    
    def finder_name
      "find_#{resource_name}"
    end
    
    def initializer_name
      "initialize_#{resource_name}"
    end
    
    def options_for_find
      returning options.clone do |options|
        OPTIONS.each { |opt| options.delete opt }
      end
    end
    
    def initializer_exists?
      controller.private_method_defined?(initializer_name) || controller.method_defined?(initializer_name)
    end
    
    def finder_exists?
      controller.private_method_defined?(finder_name) || controller.method_defined?(finder_name)
    end
    
    def parameters_for_find
      returning "params[#{param_id.inspect}]" do |params|
        params << ", #{options_for_find.inspect}" unless options_for_find.empty?
      end
    end
    
    def finding?
      options[:features].include? :find
    end
    
    def initializing?
      options[:features].include? :initialize
    end
    
    def filter_actions
      if options[:only]
        options[:only]
      else
        actions = Array(options[:also_filter])
        actions += FindOrInitializeResource.find_filter_actions if finding?
        actions += FindOrInitializeResource.initialize_filter_actions if initializing?
        actions
      end
    end
    
    def filter_name
      if finding? && initializing?
        foir_name
      elsif finding?
        finder_name
      elsif initializing?
        initializer_name
      end
    end
    
    private
    
      def build_foir
        controller.class_eval <<-STR
          def #{foir_name}
            params[#{param_id.inspect}] ? #{finder_name} : #{initializer_name}
          end
          private :#{foir_name}
        STR
      end
      
      def build_initializer
        controller.class_eval <<-STR
          def #{initializer_name}
            @#{resource_name} = #{context}.respond_to?(:build) ? #{context}.build : #{context}.new
          end
          private :#{initializer_name}
        STR
      end
      
      def build_finder
        controller.class_eval <<-STR
          def #{finder_name}
            @#{resource_name} = #{context}.find(#{parameters_for_find})
          end
          private :#{finder_name}
        STR
      end
    
      def controller_resource_name
        controller.controller_name.singularize
      end
    
  end
end
