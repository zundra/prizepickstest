module Storage
  class PowerException < StandardError; end

  class ConflictingDietsException < StandardError; end

  class MaxCapacityException < StandardError; end

  class OccupiedCageException < StandardError; end
end
