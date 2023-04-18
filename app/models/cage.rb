class Cage < ApplicationRecord
  belongs_to :diet
  has_many :dinosaurs
  before_save :validate_state
  before_destroy :validate_empty

  def validate_state
    validate_power_state
  end

  def validate_power_state
    raise Storage::PowerException.new("Cannot power down a cage housing dinosaurs") if dinosaurs.count != 0 && power_state == POWER_STATES[:down]
  end

  def validate_empty
    raise Storage::OccupiedCageException.new("Cage must be empty before destruction") if dinosaurs.count != 0
  end
end
