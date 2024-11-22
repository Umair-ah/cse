class ProjectsController < ApplicationController

  def index
    guide = Guide.find(session[:guide_id])
    @students_of_guide = guide.students.order(created_at: :desc)
  end

  def new

  end

  def edit
    @project = Project.find(params[:id])
  end

  def update
    @project = Project.find(params[:id])
    if @project.update(project_params)
      redirect_to projects_path, notice: "Saved and Calculated Total!"
    else 
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
  end


  private

  def project_params
    params.require(:project).permit(:mark1, :mark2, :mark3, :mark4, :mark5, :mark6, :mark7, :mark8, :mark9, :mark10)
  end



end