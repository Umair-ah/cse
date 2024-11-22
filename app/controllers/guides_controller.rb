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
      if (params[:category] == "mini") || (params[:category] == "major")    
        file_path = params[:file].path # Assuming you're uploading the Excel file

        # Open the Excel file
        workbook = Roo::Spreadsheet.open(file_path)

        # Access the first sheet
        sheet = workbook.sheet(0)

        # Iterate through rows, starting from the second row (assuming headers in the first row)
        sheet.each_row_streaming(offset: 1) do |row|
          # Safely extract USNs and guide name, checking for nil values
          usn1 = row[1]&.value
          usn2 = row[3]&.value
          usn3 = row[5]&.value
          guide_name = row[7]&.value

          # Skip if guide_name is blank
          next if guide_name.blank?

          # Process each student and associate them with the guide
          [usn1, usn2, usn3].compact.each do |usn| # Skip nil values
            
            begin
              student = Student.find_by!(usn: usn) # Using find_by! to explicitly raise an error if not found
              # Build or associate guide
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
      end

      redirect_to request.referrer, notice: "SUccess"

    rescue ActiveRecord::NotNullViolation => e
      flash[:alert] = "Failed to upload, make sure to create batch and then upload."
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