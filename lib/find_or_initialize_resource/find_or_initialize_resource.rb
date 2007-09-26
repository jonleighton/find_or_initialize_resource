module FindOrInitializeResource
  class << self
    def find_filter_actions
      @find_filter_actions ||= %w(show edit update destroy)
    end
    
    def initialize_filter_actions
      @initialize_filter_actions ||= %w(create new)
    end
    
    attr_writer :find_filter_actions, :initialize_filter_actions
  end
end
