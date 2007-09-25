require File.join(File.dirname(__FILE__), 'test_helper')

class FindOrInitializeResourceTest < Test::Unit::TestCase
  
  def setup
    self.class.class_eval do
      const_set :ApplicationController, Class.new(ActionController::Base)
      const_set :PostsController, Class.new(ApplicationController)
    end
  end
  
  def teardown
    self.class.class_eval do
      remove_const :PostsController
      remove_const :ApplicationController
    end
  end
  
  def test_macro_should_create_private_finder
    PostsController.find_or_initialize_resource
    assert PostsController.private_method_defined?(:find_or_initialize_post)
  end

  def test_finder_should_find
    assert_find
  end

  def test_finder_should_initialize
    PostsController.find_or_initialize_resource
    controller = PostsController.new
    post = stub
    Post.expects(:new).returns(post)
    controller.stubs(:params).returns({})
    
    assert_equal post, controller.send(:find_or_initialize_post)
  end

  def test_finder_should_build_with_association_context
    PostsController.find_or_initialize_resource :context => "current_user.posts"
    
    post = Post.new
    controller = PostsController.new
    controller.stubs(:current_user).returns(stub(:posts => mock(:build => post)))
    controller.stubs(:params).returns({})
    
    assert_equal post, controller.send(:find_or_initialize_post)
  end

  def test_before_filter_should_be_added
    PostsController.expects(:before_filter).with(
      :find_or_initialize_post,
      :only => FindOrInitializeResource.filter_actions
    )
    PostsController.find_or_initialize_resource
  end

  def test_before_filter_should_use_custom_filter_actions
    actions = %w(foo bar baz)
    FindOrInitializeResource.filter_actions = actions
    PostsController.expects(:before_filter).with(:find_or_initialize_post, :only => actions)
    PostsController.find_or_initialize_resource
  end
  
  def test_find_or_initialize_resource_model_option_should_specify_model
    assert_find :model => "Comment"
  end

  def test_find_or_initialize_resource_context_option_should_specify_context
    assert_find :context => "current_user.posts" do |controller, post|
      controller.expects(:current_user).at_least_once.returns(stub(:posts => [post]))
    end
  end
  
  def test_other_find_or_initialize_resource_options_should_be_passed_to_find
    assert_find :include => :comments
  end

  private

  def assert_find(options = {})
    model = options[:model] || "Post"
    context = options[:context] || model
    options_for_find = options.clone
    FindOrInitializeResource::Builder::OPTIONS.each { |opt| options_for_find.delete opt }
    
    PostsController.find_or_initialize_resource(options)
    @controller = PostsController.new
    resource = model.constantize.new
    
    yield @controller, resource if block_given?
    @controller.stubs(:params).returns(:id => 14)
    
    find_params = [14]
    find_params << options_for_find unless options_for_find.empty?
    @controller.instance_eval(context).expects(:find).with(*find_params).returns(resource)
    
    assert_equal resource, @controller.instance_eval("find_or_initialize_" + model.underscore)
  end
  
end
