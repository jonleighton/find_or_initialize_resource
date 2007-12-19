require File.dirname(__FILE__) + "/spec_helper"

describe FindOrInitializeResource::Builder, "with no options and a controller named 'ArticlesController'" do
  
  before do
    @controller_klass = Class.new(ActionController::Base)
    @controller_klass.stubs(:before_filter)
    @controller_klass.stubs(:controller_name).returns("articles")
    @builder = FindOrInitializeResource::Builder.new( @controller_klass, {})
  end
  
  it "should have options of { :features => [ :find, :initialize ] }" do
    @builder.options.should == { :features => [ :find, :initialize ] }
  end
  
  it "should have a reference to the controller" do
    @builder.controller.should == @controller_klass
  end
  
  it "should have a resource name of 'article'" do
    @builder.resource_name.should == "article"
  end
  
  it "should have a context of 'Article'" do
    @builder.context.should == "Article"
  end
  
  it "should have a foir name of 'find_or_initialize_article'" do
    @builder.foir_name.should == "find_or_initialize_article"
  end
  
  it "should have a finder name of 'find_article'" do
    @builder.finder_name.should == "find_article"
  end
  
  it "should have a initializer name of 'initialize_article'" do
    @builder.initializer_name.should == "initialize_article"
  end
  
  it "should have no options for find" do
    @builder.options_for_find.should be_empty
  end
  
  it "should report that no finder exists" do
    @builder.finder_exists?.should == false
  end
  
  it "should report that no initializer exists" do
    @builder.initializer_exists?.should == false
  end
  
  it "should have 'params[:id]' as its parameters for find" do
    @builder.parameters_for_find.should == "params[:id]"
  end
  
  it "should be finding" do
    @builder.should be_finding
  end
  
  it "should be initializing" do
    @builder.should be_initializing
  end
  
  it "should have the find and initialize filter actions as its filter actions" do
    @builder.filter_actions.should == FindOrInitializeResource.find_filter_actions +
                                      FindOrInitializeResource.initialize_filter_actions
  end
  
  it "should have a filter name of 'find_or_initialize_article'" do
    @builder.filter_name.should == "find_or_initialize_article"
  end
  
  it "should build the foir, finder and initializer when asked to build" do
    @builder.expects(:build_foir)
    @builder.expects(:build_finder)
    @builder.expects(:build_initializer)
    
    @builder.build
  end
  
  it "should define :find_or_initialize_article as a before filter when asked to build" do
    @controller_klass.expects(:before_filter).with(:find_or_initialize_article, anything)
    @builder.build
  end
  
  it "should have a param id of :id" do
    @builder.param_id.should == :id
  end
  
  it "should create a private find_or_initialize_article method in the controller when asked to build" do
    @builder.build
    @controller_klass.private_method_defined?("find_or_initialize_article").should == true
  end
  
  it "should create a private find_article method in the controller when asked to build" do
    @builder.build
    @controller_klass.private_method_defined?("find_article").should == true
  end
  
  it "should create a private initialize_article method in the controller when asked to build" do
    @builder.build
    @controller_klass.private_method_defined?("initialize_article").should == true
  end
  
end

Cat = Class.new

describe "A CatsController with find_or_initialize_resource" do
  
  before do
    @controller_klass = Class.new(ActionController::Base)
    @controller_klass.stubs(:controller_name).returns("cats")
    @controller_klass.stubs(:before_filter)
    @controller_klass.find_or_initialize_resource
    
    @controller = @controller_klass.new
    @controller.stubs(:params).returns({})
  end
  
  it "should call find_cat if params[:id] is defined and it is asked to find_or_initialize_cat" do
    @controller.params[:id] = 54
    @controller.expects(:find_cat)
    @controller.send :find_or_initialize_cat
  end
  
  it "should call initialize_cat if params[:id] is not defined and it is asked to find_or_initialize_cat" do
    @controller.expects(:initialize_cat)
    @controller.send :find_or_initialize_cat
  end
  
  it "should find the cat with id 43 if asked to find_cat when params[:id] is 43" do
    @controller.params[:id] = 43
    Cat.expects(:find).with(43)
    @controller.send :find_cat
  end
  
  it "should initialize a cat if asked to initialize_cat" do
    Cat.expects(:new)
    @controller.send :initialize_cat
  end
  
end

describe "A FoxController with initialize_resource and a context of 'current_user.foxes' which responds to build" do

  before do
    @controller_klass = Class.new(ActionController::Base)
    @controller_klass.stubs(:controller_name).returns("foxes")
    @controller_klass.stubs(:before_filter)
    @controller_klass.initialize_resource :context => "current_user.foxes"
    
    @controller = @controller_klass.new
    
    @current_user = stub_everything(:foxes => [])
    @controller.stubs(:current_user).returns(@current_user)
  end
  
  it "should build a new fox in the current_user.foxes collection when asked to initialize_fox" do
    @current_user.foxes.expects(:build)
    @controller.send :initialize_fox
  end

end

describe FindOrInitializeResource::Builder, "in a BoxesController, with a resource name of table" do
  
  before do
    @controller_klass = Class.new(ActionController::Base)
    @controller_klass.stubs(:controller_name).returns("boxes")
    @builder = FindOrInitializeResource::Builder.new(@controller_klass, :resource => :table)
  end
  
  it "should have a resource name of 'table'" do
    @builder.resource_name.should == "table"
  end
  
  it "should have a context of 'Table'" do
    @builder.context.should == "Table"
  end
  
  it "should have a param id of :table_id" do
    @builder.param_id.should == :table_id
  end
  
  it "should have empty options for find" do
    @builder.options_for_find.should be_empty
  end
  
end

Boot = Class.new

describe FindOrInitializeResource::Builder, "with a param id of :socks" do

  before do
    @controller_klass = Class.new(ActionController::Base)
    @controller_klass.stubs(:controller_name).returns("boots")
    
    @controller = @controller_klass.new
    @controller.stubs(:params).returns({})
    
    @builder = FindOrInitializeResource::Builder.new(@controller_klass, :param_id => :socks)
    @builder.build
  end
  
  it "should have a param id of :socks" do
    @builder.param_id.should == :socks
  end
  
  it "should find the boot with id 25 if asked to find_boot when params[:socks] is 25" do
    @controller.params[:socks] = 25
    Boot.expects(:find).with(25)
    @controller.send :find_boot
  end
  
  it "should call find_boot if params[:socks] is not nil and asked to find_or_initialize_boot" do
    @controller.params[:socks] = 25
    @controller.expects :find_boot
    @controller.send :find_or_initialize_boot
  end

end

describe FindOrInitializeResource::Builder, "with an :only option of obvious and ways" do

  before do
    @builder = FindOrInitializeResource::Builder.new(stub_everything, :only => [ :obvious, :ways ])
  end
  
  it "should have filter actions of obvious and ways" do
    @builder.filter_actions.should == [ :obvious, :ways ]
  end

end

describe FindOrInitializeResource::Builder, "awith the :optional option set to true" do

  before do
    @controller_klass = Class.new(ActionController::Base)
    @controller_klass.stubs(:controller_name).returns("boots")
    
    @controller = @controller_klass.new
    @controller.stubs(:params).returns({})
    
    @builder = FindOrInitializeResource::Builder.new(@controller_klass, :optional => true)
    @builder.build
  end
  
  it "should not call find if find_boot is called when params[:id] is nil" do
    @controller.params[:id] = nil
    Boot.expects(:find).never
    @controller.send(:find_boot).should == nil
  end

end
