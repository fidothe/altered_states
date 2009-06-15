module AlteredStates
  module StateBox
    attr_reader :state_holder, :state_marker
    
    def initialize(state_holder, state_marker)
      @state_holder = state_holder
      @state_marker = state_marker
      
      # define_delegates(state_holder)
    end
    
    def state
      (state_holder.read_attribute(state_marker) || self.class.default_state).to_sym
    end
    
    def state=(identifier)
      state_holder.update_attribute(state_marker, identifier.to_s)
    end
    
    def to_json(opts = {})
      state_holder.read_attribute(state_marker).to_json(opts)
    end
  end
end