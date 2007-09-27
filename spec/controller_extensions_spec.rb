require File.dirname(__FILE__) + "/spec_helper"

describe FindOrInitializeResource::ControllerExtensions do
  
  before do
    @controller_klass = Class.new(ActionController::Base)
  end
  
  it "should create a new Builder, passing the opts, when find_or_initialize_resource is called" do
    FindOrInitializeResource::Builder.expects(:new).
      with(@controller_klass, :foo => :bar).
      returns(stub_everything)
    
    @controller_klass.find_or_initialize_resource :foo => :bar
  end
  
  it "should create a new Builder, adding :features => [ :find ] to the opts, when find_resource is called" do
    FindOrInitializeResource::Builder.expects(:new).
      with(@controller_klass, :foo => :bar, :features => [ :find ]).
      returns(stub_everything)
    
    @controller_klass.find_resource :foo => :bar
  end
  
  it "should create a new Builder, adding :features => [ :initialize ] to the opts, when initialize_resource is called" do
    FindOrInitializeResource::Builder.expects(:new).
      with(@controller_klass, :foo => :bar, :features => [ :initialize ]).
      returns(stub_everything)
    
    @controller_klass.initialize_resource :foo => :bar
  end
  
  it "should create a new Builder, adding :resource => :hammer to the opts, " +
      "when find_or_initialize_resource is called with :hammer as the first parameter" do
    FindOrInitializeResource::Builder.expects(:new).
      with(@controller_klass, :resource => :hammer).
      returns(stub_everything)
    
    @controller_klass.find_or_initialize_resource :hammer
  end
  
end
