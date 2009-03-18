require 'set'

module AlteredStates
  module ClassMethods
    def map_state_machine(state_machine_class, column_name)
      self.class_eval do
        define_method(column_name) do
          ivar_name = "@#{column_name}".to_sym
          return instance_variable_get(ivar_name) if instance_variable_defined?(ivar_name)
          instance_variable_set(ivar_name, state_machine_class.new(self, column_name))
        end
      end
      
      define_delegates(state_machine_class, column_name)
    end
    
    private
    
    def methods_in_need_of_delegates(state_machine_class)
      defined_methods = state_machine_class.instance_methods(false).collect { |m| m.to_sym }
      (defined_methods.to_set | state_machine_class.all_handled_requests).to_a
    end
    
    def define_delegates(state_machine_class, column_name)
      methods_in_need_of_delegates(state_machine_class).each do |method|
        self.class_eval <<-EOM, __FILE__, __LINE__
          def #{method}(*args)
            #{column_name}.#{method}(*args)
          end
        EOM
      end
    end
  end
  
  def self.append_features(klass)
    # Get with the class methods pls
    klass.extend(ClassMethods)
    
    super(klass)
  end
end