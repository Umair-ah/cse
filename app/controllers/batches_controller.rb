class BatchesController < ApplicationController
  before_action :set_batch, only: %i[ show edit update destroy ]
  before_action :authenticate_user!, except: %i[ show index search ]


  def search
    begin
      usn_query = params[:query]&.to_s&.strip&.upcase
      @student = Student.find_by(usn: usn_query)

      respond_to do |format|
        format.turbo_stream do
          render turbo_stream:
          turbo_stream.update(
            "usn_query",
            partial: "shared/usn_query"
          )
        end
      end
    rescue StandardError => e
      redirect_to batches_path, alert: "Nothing Found!"
    end

  end 



  # GET /batches or /batches.json
  def index
    @batches = Batch.all
  end

  # GET /batches/1 or /batches/1.json
  def show
    @batch_students = @batch.students.order(:usn)
  end

  def upload
    begin
      if params[:file].present?
        file = params[:file]
        spreadsheet = Roo::Spreadsheet.open(file.path)
    
    
        # Assuming the first row contains headers, start from the second row
        (2..spreadsheet.last_row).each do |i|
          row_data = spreadsheet.row(i)
    
          # Extract USN and NAME from the current row
          usn = row_data[1] # Assuming USN is in the second column (index 1)
          name = row_data[2] # Assuming NAME is in the third column (index 2)

    
          # Check if both USN and NAME are present
          if usn.present? && name.present?
            student = Student.find_or_create_by!(usn: usn&.to_s&.strip&.upcase, name: name&.to_s&.strip&.upcase, batch_id: params[:batch_id])
          end
        end
    
        flash[:notice] = "File uploaded successfully!"
      else
        flash[:alert] = "Please upload a file."
      end
    
      redirect_to batch_path(params[:batch_id])
    rescue ArgumentError => e
      redirect_to batch_path(params[:batch_id]), alert: "Enter Excel Format Only"
    end
  end
  

  # GET /batches/new
  def new
    @batch = Batch.new
  end

  # GET /batches/1/edit
  def edit
  end

  # POST /batches or /batches.json
  def create
    @batch = Batch.new(batch_params)

    respond_to do |format|
      if @batch.save
        format.html { redirect_to @batch, notice: "Batch was successfully created." }
        format.json { render :show, status: :created, location: @batch }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @batch.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /batches/1 or /batches/1.json
  def update
    respond_to do |format|
      if @batch.update(batch_params)
        format.html { redirect_to @batch, notice: "Batch was successfully updated." }
        format.json { render :show, status: :ok, location: @batch }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @batch.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /batches/1 or /batches/1.json
  def destroy
    @batch.destroy

    respond_to do |format|
      format.html { redirect_to batches_path, status: :see_other, notice: "Batch was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_batch
      @batch = Batch.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def batch_params
      params.require(:batch).permit(:year)
    end
end
