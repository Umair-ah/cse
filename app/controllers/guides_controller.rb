class GuidesController < ApplicationController
  before_action :authenticate_user!


  def show

  end

  def upload
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
        # Find student by USN

        student = Student.find_or_create_by!(usn: usn)

        if student
          # Build or associate guide
          guide = Guide.find_or_create_by!(name: guide_name)
          students_guide = StudentsGuide.find_or_create_by(student: student, guide: guide)
        else
          Rails.logger.warn "Student with USN #{usn} not found"
        end
      end
    end

    redirect_to request.referrer


  end


end