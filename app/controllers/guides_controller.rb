class GuidesController < ApplicationController

  def update_major
    student = Student.find(params[:student_id])
    guide = student.guide

    if guide
      project = Project.create!(title: "Major Project", student: student, mark1: 0, mark2: 0, mark3: 0, mark4: 0, mark5: 0, mark6: 0, mark7: 0, mark8: 0, mark9: 0, mark10: 0)
      StudentsProject.create!(student: student, project: project)
      redirect_to request.referrer, notice: "Updated"
    else
      redirect_to request.referrer, alert: "Select Guide"
    end


  end

  def update_mini
    student = Student.find(params[:student_id])
    guide = student.guide

    if guide

      project = Project.create!(title: "Mini Project", student: student, mark1: 0, mark2: 0, mark3: 0, mark4: 0, mark5: 0, mark6: 0, mark7: 0, mark8: 0, mark9: 0, mark10: 0)
      StudentsProject.create!(student: student, project: project)
      redirect_to request.referrer, notice: "Updated"
    else
      redirect_to request.referrer, alert: "Select Guide"
    end


  end

  def update_guide
    begin
      guide = Guide.find(params[:guide_id])
      student = Student.find(params[:student_id])
      students_guide = StudentsGuide.find_by!(student: student)
      students_guide.update!(student: student, guide: guide)
    rescue ActiveRecord::RecordNotFound
      StudentsGuide.create!(student: student, guide: guide)

    end
    redirect_to request.referrer, notice: "Updated"

  end



  def show

  end

  def upload
    begin
        
      file_path = params[:file].path 

      if !file_path.present? || !params[:category].in?(['mini', 'major'])
        raise NameError, "Upload Excel Guide List and Select Project Type (Mini or Major)!"
      end


      workbook = Roo::Spreadsheet.open(file_path)

      sheet = workbook.sheet(0)

      sheet.each_row_streaming(offset: 1) do |row|
        
        usn1 = row[1]&.value&.strip&.upcase
        usn2 = row[3]&.value&.strip&.upcase
        usn3 = row[5]&.value&.strip&.upcase
        guide_name = row[7]&.value&.strip&.upcase


        next if guide_name.blank?

        [usn1, usn2, usn3].compact.each do |usn| 
          
          begin
        
            student = Student.find_by!(usn: usn) 

            guide = Guide.find_or_create_by!(name: guide_name) do |guide|
              guide.password = "pda123"
            end
            StudentsGuide.find_or_create_by!(student: student, guide: guide)

            if params[:category] == "mini"

              mini_project = Project.find_or_create_by!(title: "Mini Project", student: student, mark1: 0, mark2: 0, mark3: 0, mark4: 0, mark5: 0, mark6: 0, mark7: 0, mark8: 0, mark9: 0, mark10: 0)
              StudentsProject.find_or_create_by!(student: student, project: mini_project)
            elsif params[:category] == "major"

              major_project = Project.find_or_create_by!(title: "Major Project", student: student, mark1: 0, mark2: 0, mark3: 0, mark4: 0, mark5: 0, mark6: 0, mark7: 0, mark8: 0, mark9: 0, mark10: 0)
              StudentsProject.find_or_create_by!(student: student, project: major_project)
            end
            

          rescue ActiveRecord::RecordNotFound
            Rails.logger.warn "Student with USN #{usn} not found"
          rescue ActiveRecord::RecordInvalid => e
            Rails.logger.warn "Validation failed: #{e.message}"
          end
        end
      end
      redirect_to request.referrer, notice: "Success!"


    rescue ActiveRecord::NotNullViolation => e
      flash[:alert] = "Failed to upload, make sure to create batch and then upload."
      redirect_to request.referrer

    rescue NameError => e
      flash[:alert] = "Upload Excel Guide List and Select Project Type (Mini or Major)!"
      redirect_to request.referrer
    end


  end

  def clean
    StudentsProject.destroy_all
    Project.destroy_all
    StudentsGuide.destroy_all
    Guide.destroy_all
    redirect_to request.referrer, notice: "Cleaned!"
  end


  def display_guides
    if params[:query]
      @guides = Guide.where("name ILIKE ?", "%#{params[:query]}%")
    else
      @guides = []
    end
  end

  def guide_login

  end

  def create
    guide = Guide.find_by!(name: params[:guide_name])
    puts "#{guide.name}"
    if guide&.authenticate(params[:password])
      session[:guide_id] = guide.id
      redirect_to projects_path, notice: "Logged in successfully."
    else
      flash[:alert] = "Invalid password."
      render :guide_login
    end
  end

  def display_students_of_guide
    guide = Guide.find(session[:guide_id])
    @students = guide.students
  end


 

  def destroy
    session[:guide_id] = nil
    redirect_to root_path, notice: "Logged out successfully."
  end


end