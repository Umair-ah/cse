class GuidesController < ApplicationController


  def show

  end

  def upload
    begin
      
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
            mini_project = Project.find_or_create_by!(title: "Mini Project", student: student, mark1: 0, mark2: 0, mark3: 0, mark4: 0, mark5: 0, mark6: 0, mark7: 0, mark8: 0, mark9: 0, mark10: 0)
            major_project = Project.find_or_create_by!(title: "Major Project", student: student, mark1: 0, mark2: 0, mark3: 0, mark4: 0, mark5: 0, mark6: 0, mark7: 0, mark8: 0, mark9: 0, mark10: 0)
            StudentsProject.find_or_create_by!(student: student, project: mini_project)
            StudentsProject.find_or_create_by!(student: student, project: major_project)

          rescue ActiveRecord::RecordNotFound
            Rails.logger.warn "Student with USN #{usn} not found"
          rescue ActiveRecord::RecordInvalid => e
            Rails.logger.warn "Validation failed: #{e.message}"
          end

          # student = Student.find_by(usn: usn)

          # if student
          #   # Build or associate guide
          #   guide = Guide.find_or_create_by!(name: guide_name, password_digest: "pda123")
          #   students_guide = StudentsGuide.find_or_create_by(student: student, guide: guide)
          # else
          #   Rails.logger.warn "Student with USN #{usn} not found"
          # end
        end
      end

      redirect_to request.referrer

    rescue ActiveRecord::NotNullViolation => e
      flash[:alert] = "Failed to upload, make sure to create batch and then upload."
      redirect_to request.referrer
    end


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