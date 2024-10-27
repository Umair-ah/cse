class AdministrationsController < ApplicationController
  before_action :set_administration, only: %i[ show edit update destroy ]


  # GET /administrations/new
  def new
    @administration = Administration.new
  end

  # GET /administrations/1/edit
  def edit
  end

  # POST /administrations or /administrations.json
  def create
    @administration = Administration.new(administration_params)

    respond_to do |format|
      if @administration.save
        format.html { redirect_to request.referrer, notice: "Administration was successfully created." }
        format.json { render :show, status: :created, location: @administration }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @administration.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /administrations/1 or /administrations/1.json
  def update
    respond_to do |format|
      if @administration.update(administration_params)
        format.html { redirect_to request.referrer, notice: "Administration was successfully updated." }
        format.json { render :show, status: :ok, location: @administration }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @administration.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /administrations/1 or /administrations/1.json
  def destroy
    @administration.destroy

    respond_to do |format|
      format.html { redirect_to administrations_path, status: :see_other, notice: "Administration was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_administration
      @administration = Administration.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def administration_params
      params.require(:administration).permit(:name, :degree, :position, :department, :image)
    end
end
