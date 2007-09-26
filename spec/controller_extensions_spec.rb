require File.dirname(__FILE__) + "/spec_helper"

describe FindOrInitializeResource::ControllerExtensions do
  
  before do
    @controller_klass = Class.new(ActionController::Base)
  end
  
  it "should create a new Builder, adding :features => [ :find, :initialize ] to the opts, " +
     "when find_or_initialize_resource is called" do
    
    FindOrInitializeResource::Builder.expects(:new).
      with(@controller_klass, { :foo => :bar }).
      returns(stub_everything)
    
    @controller_klass.find_or_initialize_resource :foo => :bar
  end
  
  it "should create a new Builder, adding :features => [ :find ], when find_resource is called" do
    FindOrInitializeResource::Builder.expects(:new).
      with(@controller_klass, { :foo => :bar, :features => [ :find ] }).
      returns(stub_everything)
    @controller_klass.find_resource :foo => :bar
  end
  
  it "should create a new Builder, adding :features => [ :initialize ], when initialize_resource is called" do
    FindOrInitializeResource::Builder.expects(:new).
      with(@controller_klass, { :foo => :bar, :features => [ :initialize ] }).
      returns(stub_everything)
    @controller_klass.initialize_resource :foo => :bar
  end
  
end
