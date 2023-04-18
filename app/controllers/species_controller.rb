class SpeciesController < ApplicationController
  before_action :set_species, only: %i[show edit update destroy]

  # GET species.json
  def index
    @species = Species.all
  end

  # GET /species/1.json
  def show
  end

  # POST /species.json
  def create
    @species = Species.new(species_params)

    respond_to do |format|
      if @species.save
        format.json { render :show, status: :created, location: @species }
      else
        format.json { render json: @species.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /species/1.json
  def update
    respond_to do |format|
      if @species.update(species_params)
        format.json { render :show, status: :ok, location: @species }
      else
        format.json { render json: @species.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /species/1.json
  def destroy
    @species.destroy

    respond_to do |format|
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_species
    @species = Species.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def species_params
    params.require(:species).permit(:name, :species_id, :diet_id, :species_id)
  end
end
