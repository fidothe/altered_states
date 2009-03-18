require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe AlteredStates do
  before(:each) do
    @klass = Class.new
    @klass.class_eval { include AlteredStates }
    
    @state_machine_class = Class.new
    @state_machine_class.stubs(:all_handled_requests).returns([:gubbins])
    @state_machine_class.class_eval do
      def initialize(*args); end
      
      def fnordy(*args); end
    end
  end
  
  it "should export a class method for mapping the state machine to its persistence attribute" do
    @klass.map_state_machine @state_machine_class, :column_name
    
    @klass.new.should respond_to(:column_name)
  end
  
  
  describe "instances of the context class" do
    before(:each) do
      @klass.map_state_machine @state_machine_class, :column_name
    end
    
    it "should create an instance of the state machine class when asked for the :column_name attr" do
      context = @klass.new
      
      context.column_name.should be_instance_of(@state_machine_class)
    end
    
    it "should reuse one state machine instance in a context instance" do
      context = @klass.new
      
      context.column_name.should === context.column_name
    end
    
    it "should have one, separate, state machine instance per context instance" do
      context1 = @klass.new
      context2 = @klass.new
      
      context1.column_name != context2.column_name
    end
    
    describe "state machine method delegates" do
      before(:each) do
        @context = @klass.new
      end
      
      it "should delegate the 'fnordy' method" do
        @context.column_name.expects(:fnordy).with(1,2,3)
        
        @context.fnordy(1,2,3)
      end
      
      it "should delegate the 'gubbins' method" do
        @context.column_name.expects(:gubbins).with(1,2,3)
        
        @context.gubbins(1,2,3)
      end
    end
  end
end