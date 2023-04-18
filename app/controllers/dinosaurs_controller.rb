class DinosaursController < ApplicationController
  before_action :set_dinosaur, only: %i[show edit update destroy]

  # GET dinosaurs.json
  def index
    @dinosaurs = Dinosaur.all
  end

  # GET /dinosaurs/1.json
  def show
  end

  # GET /dinosaurs/1/edit
  def edit
  end

  # POST /dinosaurs.json
  def create
    @dinosaur = Dinosaur.new(dinosaur_params)

    respond_to do |format|
      if @dinosaur.save
        format.json { render :show, status: :created, location: @dinosaur }
      else
        format.json { render json: @dinosaur.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /dinosaurs/1.json
  def update
    respond_to do |format|
      if @dinosaur.update(dinosaur_params)
        format.json { render :show, status: :ok, location: @dinosaur }
      else
        format.json { render json: @dinosaur.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /dinosaurs/1.json
  def destroy
    @dinosaur.destroy

    respond_to do |format|
      format.json { head :no_content }
    end
  end

  # ADD_TO_CAGE /dinosaurs/1/add_to_available_cage/1.json
  def add_to_available_cage
    cage = Cage.find(params[:cage_id])
    @dinosaur.add_to_cage!(cage)
    respond_to do |format|
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_dinosaur
    @dinosaur = Dinosaur.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def dinosaur_params
    params.require(:dinosaur).permit(:name, :species_id, :diet_id, :cage_id)
  end
end
