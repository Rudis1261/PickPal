class RoleController < ApplicationController
  def index
    return render :json => Role.all
  end

  def show
    id_pattern = /^[0-9]+$/
    return ApplicationHelper.error('No id provided') if !params[:id] || params[:id].scan(id_pattern).first != params[:id]
    return render :json => Role.find(params[:id])
  end
end
