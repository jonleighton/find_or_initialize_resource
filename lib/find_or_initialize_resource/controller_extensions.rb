module FindOrInitializeResource
  module ControllerExtensions
    def find_or_initialize_resource(options = {})
      FindOrInitializeResource::Builder.new(self, options).build
    end
    
    def find_resource(options = {})
      find_or_initialize_resource(options.merge(:features => [ :find ]))
    end
    
    def initialize_resource(options = {})
      find_or_initialize_resource(options.merge(:features => [ :initialize ]))
    end
  end
end
