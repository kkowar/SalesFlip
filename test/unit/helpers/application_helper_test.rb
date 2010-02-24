require File.dirname(__FILE__) + '/../../test_helper'
require 'action_view/test_case'
require 'action_view/helpers'
require 'open-uri'

class ApplicationHelperTest < ActionView::TestCase

  include ApplicationHelper                                                            
  
  should "link to create a new model" do
    assert_equal add_new('Add Lead','/leads/new'), "<a href='/leads/new' id='new'><b>+</b>Add Lead</a>"
  end
  
  context "show_attribute" do

    setup do
      @lead= Lead.make
    end
    
    should "display I18n label and a model's attribute if it is present" do
      assert_equal show_attribute(@lead,'first_name'), "<dt>First Name</dt><dd>Fern</dd>"
    end

    should "display I18n label and custom text if a model's attribute is present" do
      assert_equal show_attribute(@lead,'first_name',"<b>#{@lead.first_name}</b>"), "<dt>First Name</dt><dd><b>Fern</b></dd>"
    end

  end
  
  context "rating_for" do
    
    should "show rating in darkened unicode stars if rating is present" do
      @lead= Lead.make(:rating=>1)
      assert_equal rating_for(@lead), "<span class='rating'><span class='on'>&#9733;</span><span class='off'>&#9733;</span><span class='off'>&#9733;</span><span class='off'>&#9733;</span><span class='off'>&#9733;</span></span>"
    end

    should "show grayed out unicode stars if rating is not present" do
      @lead= Lead.make
      assert_equal rating_for(@lead), "<span class='rating'><span class='off'>&#9733;</span><span class='off'>&#9733;</span><span class='off'>&#9733;</span><span class='off'>&#9733;</span><span class='off'>&#9733;</span></span>"
    end

  end

end
