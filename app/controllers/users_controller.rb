class UsersController < InheritedResources::Base
  skip_before_filter :authenticate_user!, :only => [:new, :create]

  def create
    create! do |success, failure|
      success.html { redirect_to root_path }
    end
  end
end