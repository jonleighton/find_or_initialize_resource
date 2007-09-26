require File.dirname(__FILE__) + "/spec_helper"

describe FindOrInitializeResource do
  it "should have show, edit, update, destroy as default find filter actions" do
    FindOrInitializeResource.find_filter_actions.should == %w(show edit update destroy)
  end
  
  it "should have show, edit, update, destroy as default initialize filter actions" do
    FindOrInitializeResource.initialize_filter_actions.should == %w(create new)
  end
  
  it "should have foo, bar and baz as find filter actions when they are set" do
    FindOrInitializeResource.find_filter_actions = %w(foo bar baz)
    FindOrInitializeResource.find_filter_actions.should == %w(foo bar baz)
  end
  
  it "should have gee and goo as initialize filter actions when they are set" do
    FindOrInitializeResource.initialize_filter_actions = %w(gee goo)
    FindOrInitializeResource.initialize_filter_actions.should == %w(gee goo)
  end
end
