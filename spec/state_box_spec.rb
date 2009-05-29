require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe AlteredStates::StateBox do
  before(:each) do
    @mock_state_holder = (Class.new).new
    @klass = Class.new
    @klass.class_eval { include AlteredStates::StateBox }
  end
  
  it "should provide a initialize method with stores the state holder instance and the state persistence attribute" do
    @klass.new(@mock_state_holder, :column_name).should be_instance_of(@klass)
  end
  
  describe "instances including it" do
    before(:each) do
      @state_marker = @klass.new(@mock_state_holder, :column_name)
    end
    
    it "should export a class method for defining the state marker attribute" do
      @state_marker.state_marker.should == :column_name
    end
    
    describe "instances including the module" do
      it "should attempt to serialize itself in a sensible way" do
        @mock_state_holder.expects(:update_attribute).with(:column_name, 'state_id')
        
        @state_marker.state = :state_id
      end
      
      it "should read itself in a sensible way" do
        @mock_state_holder.expects(:read_attribute).with(:column_name).returns('state_id')
        
        @state_marker.state.should == :state_id
      end
      
      it "should cope when there's no value for state in the AR class" do
        @klass.expects(:default_state).returns(:default)
        @mock_state_holder.expects(:read_attribute).with(:column_name).returns(nil)
        
        @state_marker.state.should == :default
      end
    end
  end
end