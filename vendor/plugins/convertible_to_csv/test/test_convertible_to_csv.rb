require 'rubygems'
require 'yaml'
require 'active_record'
require 'lib/convertible_to_csv'

config = open("test/config.yml") { |f| YAML.load(f.read) }

ActiveRecord::Base.establish_connection(config["database"])

class Customer < ActiveRecord::Base
  acts_as_convertible_to_csv :header => false, :fields => %w(business_name)
end

class OtherCustomer < Customer
  acts_as_convertible_to_csv :header => false, :fields => %w(id business_name contact_name)
end

class FormattedCustomer < Customer
  acts_as_convertible_to_csv :header => false, :fields => %w(id business_name contact_name), :format_options => {:id => :format_integer, :contact_name => :format_contact_name, 'business_name' => 'format_business_name'}
  
  def format_contact_name(field_name, value)
    value.upcase
  end
  
  def format_business_name(field_name, value)
    '1234'
  end
  
  # a generic formatting field (same function could be used for multiple fields)
  def format_integer(field_name, value)
    sprintf('%010d', value)
  end
end



class ConvertibleToCvsTest < Test::Unit::TestCase
  
  def setup
    ActiveRecord::Base.connection.drop_table :customers rescue nil
    ActiveRecord::Base.connection.create_table :customers do |t|
        t.column :business_name, :string
        t.column :email_address , :string
        t.column :contact_name , :string
    end
    Customer.create :id => 1, :business_name => 'Business One', :email_address => 'b1@business.com', :contact_name => 'fred'
    Customer.create :id => 2, :business_name => 'Business Two', :email_address => 'b2@business.com', :contact_name => 'bill'
    Customer.create :id => 3, :business_name => 'Business Three', :email_address => 'b3@business.com', :contact_name => 'frank'
    @customers = Customer.find(:all)
  end
  
  def test_not_nil
    assert_not_nil @customers
  end

  def test_formatting_options
    assert_equal %q(0000000002,1234,BILL), FormattedCustomer.find(2).to_csv
  end
      
  def test_record_data
    assert_equal 'Business One', @customers[0].business_name
    assert_equal 'Business Two', @customers[1].business_name
    assert_equal 'Business Three', @customers[2].business_name
  end
  
  def test_csv_header
    assert_equal ['business_name'], Customer.csv_header
    assert_equal ['id', 'business_name', 'contact_name'], OtherCustomer.csv_header
  end
  
  def test_record_to_csv
    assert_equal %q(Business Three), Customer.find(3).to_csv
    assert_equal %q(Business One), Customer.find(1).to_csv
    
    assert_equal %q(3,Business Three,frank), OtherCustomer.find(3).to_csv
    assert_equal %q(1,Business One,fred), OtherCustomer.find(1).to_csv
  end
  
  def test_model_to_csv
    csv = OtherCustomer.find(:all).to_csv
    assert_kind_of Array, csv
    assert_equal 3, csv.size
    
    # check that each line from csv is the same as calling to_csv on each customer object
    csv.each do |csv_line|
      id = csv_line.split(",")[0]
      assert_equal csv_line, OtherCustomer.find(id).to_csv
    end
  end
  
end