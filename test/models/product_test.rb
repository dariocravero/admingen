require File.expand_path(File.dirname(__FILE__) + '/../test_config.rb')

describe "Product Model" do
  it 'can construct a new instance' do
    @product = Product.new
    refute_nil @product
  end
end
