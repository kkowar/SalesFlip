class AccountsController < InheritedResources::Base
  before_filter :merge_updater_id, :only => [ :update ]

  respond_to :html
  respond_to :xml

  def create
    create! do |success, failure|
      success.html { return_to_or_default account_path(@account) }
      success.xml { head :ok }
    end
  end

  def destroy
    resource
    @account.updater_id = current_user.id
    @account.destroy
    redirect_to accounts_path
  end

protected
  def collection
    @page = params[:page] || 1
    @per_page = 10
    @accounts ||= hook(:accounts_collection, self,
                       :pages => { :page => @page, :per_page => @per_page }).last
    @accounts ||= Account.for_company(current_user.company).permitted_for(current_user).
      not_deleted.sort_by(&:name).paginate(:per_page => @per_page, :page => @page)
  end

  def resource
    @account ||= hook(:accounts_resource, self).last
    @account ||= Account.for_company(current_user.company).permitted_for(current_user).
      where(:_id => params[:id]).first
  end

  def begin_of_association_chain
    current_user
  end

  def merge_updater_id
    params[:account].merge!(:updater_id => current_user.id) if params[:account]
  end

  def build_resource
    @account ||= begin_of_association_chain.accounts.build({ :assignee_id => current_user.id }.
                                                           merge(params[:account] || {}))
  end
end
