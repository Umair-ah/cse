class ProjectsController < ApplicationController

  def index
    guide = Guide.find(session[:guide_id])
    @students_of_guide = guide.students
  end

  def new

  end

  def edit
    @student = Student.find(params[:id])
    
  end

  def update
  end

  def destroy
  end



end