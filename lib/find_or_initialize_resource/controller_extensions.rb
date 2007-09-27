module FindOrInitializeResource
  module ControllerExtensions
    def find_or_initialize_resource(*args)
      options = args.last.is_a?(Hash) ? args.last : {}
      options[:resource] = args.first unless args.first.is_a?(Hash)
      
      FindOrInitializeResource::Builder.new(self, options).build
    end
    
    def find_resource(*args)
      find_or_initialize_resource(*process_args_for_foir(args, :find))
    end
    
    def initialize_resource(*args)
      find_or_initialize_resource(*process_args_for_foir(args, :initialize))
    end
    
    private
    
      def process_args_for_foir(args, *features)
        if args.empty?
          args = [{}]
        elsif !args.first.is_a?(Hash) && args[1].nil?
          args[1] = {}
        end
        args.last.merge!(:features => features)
        args
      end
  end
end
