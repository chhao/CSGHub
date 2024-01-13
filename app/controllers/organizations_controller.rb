class OrganizationsController < ApplicationController
  before_action :authenticate_user
  before_action :check_user_info_integrity

  def new
  end

  def show
    @organization = Organization.find_by(name: params[:id])
    unless @organization
      flash[:alert] = "未找到对应的组织"
      return redirect_to "/profile/#{current_user.name}"
    end
    user_org_role = current_user.org_role(@organization)
    unless user_org_role
      return redirect_to errors_unauthorized_path
    end
    @admin = user_org_role == 'admin'
    @members = @organization.members
    @models = Starhub.api.get_org_models(@organization.name, current_user.name)
    @datasets = Starhub.api.get_org_datasets(@organization.name, current_user.name)
  end
end