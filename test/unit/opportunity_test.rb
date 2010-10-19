require 'test_helper'

class OpportunityTest < ActiveSupport::TestCase
  context 'Class' do
    should_have_key :title, :stage, :close_on, :probability, :amount, :discount,
      :background_info, :created_at, :updated_at
    should_belong_to :assignee, :user, :contact
    should_have_many :comments, :tasks
    should_have_constant :stages
    should_validate_presence_of :title
    should_have_uploader :attachment
    should_act_as_paranoid
    
    context 'assigned_to' do
      setup do
        @user = User.make :annika
        @user2 = User.make :benny
        @opportunity = Opportunity.make :assignee => @user
        @opportunity2 = Opportunity.make :assignee => @user2
      end
      
      should 'only return opportunities assigned to the specified user id' do
        assert_equal [@opportunity], Opportunity.assigned_to(@user.id).to_a
        assert_equal [@opportunity2], Opportunity.assigned_to(@user2.id).to_a
      end
      
      should 'work with string ids' do
        assert_equal [@opportunity], Opportunity.assigned_to(@user.id.to_s).to_a
      end
    end
    
    context 'for_company' do
      setup do
        @user = User.make :annika
        @user2 = User.make :benny
        @user3 = User.make :company => @user.company
        @opportunity = Opportunity.make :user => @user
        @opportunity2 = Opportunity.make :user => @user2
        @opportunity3 = Opportunity.make :user => @user3
      end
      
      should 'only return occupations belonging to users in the supplied company' do
        assert_equal [@opportunity, @opportunity3], Opportunity.for_company(@user.company).to_a
        assert_equal [@opportunity2], Opportunity.for_company(@user2.company).to_a
      end
    end
    
    context 'create_for' do
      setup do
        @contact = Contact.make
      end
      
      should 'create an opportunity from the supplied contact' do
        opportunity = Opportunity.create_for(@contact, :opportunity => { :title => 'An opportunity' })
        assert_equal 1, Opportunity.count
        assert_equal 'An opportunity', Opportunity.first.title
      end
      
      should 'assign the opportunity to the supplied contact' do
        opportunity = Opportunity.create_for(@contact, :opportunity => { :title => 'An opportunity' })
        assert_equal 1, @contact.opportunities.count
      end
      
      should 'not create the opportunity if the supplied contact is invalid' do
        opportunity = Opportunity.create_for(Contact.new, :opportunity => { :title => 'An opportunity' })
        assert_equal 0, Opportunity.count
      end
    end
  end
  
  context 'Instance' do    
    should 'have default stage of "prospecting"' do
      @opportunity = Opportunity.make(:stage => nil)
      assert_equal 'prospecting', @opportunity.stage
    end
    
    should 'not default stage to "prospecting" if stage is already set' do
      @opportunity = Opportunity.make(:stage => 'negotiation')
      assert_equal 'negotiation', @opportunity.stage
    end
    
    should 'alias title to name' do
      @opportunity = Opportunity.make(:title => 'a title')
      assert_equal 'a title', @opportunity.name
    end
  end
end