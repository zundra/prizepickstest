class Dinosaur < ApplicationRecord
  before_save :validate_state
  belongs_to :species
  belongs_to :diet
  belongs_to :cage, optional: true

  def add_to_cage!(cage)
    self.cage = cage
    save!
  rescue Storage::MaxCapacityException
    cage = Cage.create(diet: diet, power_state: POWER_STATES[:active])
    self.cage = cage
    save!
  end

  def validate_state
    return true unless cage
    validate_diet_compatability
    validate_power_state
    validate_capacity
  end

  def validate_diet_compatability
    raise Storage::ConflictingDietsException.new("#{cage.diet&.name} cannot be stored with #{diet&.name}") unless cage.diet&.name == diet&.name
  end

  def validate_power_state
    raise Storage::PowerException.new("Cage must be powered up before housing a dinosaur") unless cage.power_state == POWER_STATES[:active]
  end

  def validate_capacity
    raise Storage::MaxCapacityException.new("Cage is at max capacity and unable to house additional dinosaurs") if cage&.dinosaurs&.length == cage.max_capacity
  end
end
