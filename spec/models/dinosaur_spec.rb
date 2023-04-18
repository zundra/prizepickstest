require "rails_helper"

RSpec.describe Dinosaur, type: :model do
  let!(:diet_carnivore) { create(:diet) }
  let!(:diet_herbivore) { create(:diet, name: DIETS[:herbivore]) }

  context "Dinosaur persistence" do
    it "baseline create" do
      expect(create(:dinosaur, diet: diet_herbivore)).to be
    end

    it "has a diet_id" do
      expect(create(:dinosaur, diet: diet_carnivore).diet_id).to be
    end
  end

  context "storing dinosaurs based on the dinosaur diets" do
    it "cannot store the dinosaur in a cage with a conflicting diet allocation" do
      dino = create(:dinosaur, diet: create(:diet, name: diet_carnivore))
      cage = create(:cage, power_state: POWER_STATES[:active], diet: create(:diet, name: diet_herbivore))
      dino.cage = cage
      expect { dino.save }.to raise_exception(Storage::ConflictingDietsException)
    end

    it "successfully stores the dinosaur in a cage with a matching diet allocation" do
      dino = create(:dinosaur, diet: diet_carnivore)
      cage = create(:cage, power_state: POWER_STATES[:active], diet: diet_carnivore)
      dino.cage = cage
      expect { dino.save }.not_to raise_exception
    end
  end

  context "storing dinosaurs based on the cage power state" do
    it "cannot store the dinosaur in a powered down cage" do
      dino = create(:dinosaur, diet: diet_carnivore)
      cage = create(:cage, diet: diet_carnivore)
      dino.cage = cage
      expect { dino.save }.to raise_exception(Storage::PowerException)
    end

    it "successfully stores the dinosaur in a powered cage" do
      dino = create(:dinosaur, diet: diet_carnivore)
      cage = create(:cage, power_state: POWER_STATES[:active], diet: diet_carnivore)
      dino.cage = cage
      expect { dino.save }.not_to raise_exception
    end
  end

  context "storing dinosaurs while considering cage capacity" do
    it "cannot store the dinosaur in a cage at max capacity" do
      dino = create(:dinosaur, diet: diet_carnivore)
      cage = create(:cage, power_state: POWER_STATES[:active], max_capacity: 1, diet: diet_carnivore)
      dino.cage = cage
      expect { dino.save }.to_not raise_exception
      dino.cage.dinosaurs.reload
      dino = create(:dinosaur, diet: diet_carnivore)
      dino.cage = cage
      expect { dino.save }.to raise_exception(Storage::MaxCapacityException)
    end
  end

  context "storing dinosaurs using instance helper method gracefully handles creating a new cage if the current cage is full" do
    it "cannot store the dinosaur in a cage at max capacity" do
      dino = create(:dinosaur, diet: diet_carnivore)
      cage = create(:cage, power_state: POWER_STATES[:active], max_capacity: 1, diet: diet_carnivore)
      dino.cage = cage
      expect { dino.save }.to_not raise_exception
      dino.cage.dinosaurs.reload
      dino = create(:dinosaur, diet: diet_carnivore)
      expect { dino.add_to_cage!(cage) }.to change { Cage.count }.by(1)
    end
  end
end
