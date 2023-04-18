class CagesController < ApplicationController
  before_action :set_cage, only: %i[show edit update destroy]

  # GET cages.json
  def index
    @cages = Cage.all
  end

  # GET /cages/1.json
  def show
  end

  # POST /cages.json
  def create
    @cage = Cage.new(cage_params)

    respond_to do |format|
      if @cage.save
        format.json { render :show, status: :created, location: @cage }
      else
        format.json { render json: @cage.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /cages/1.json
  def update
    respond_to do |format|
      if @cage.update(cage_params)
        format.json { render :show, status: :ok, location: @cage }
      else
        format.json { render json: @cage.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /cages/1.json
  def destroy
    @cage.destroy

    respond_to do |format|
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_cage
    @cage = Cage.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def cage_params
    params.require(:cage).permit(:name, :species_id, :diet_id, :cage_id)
  end
end
