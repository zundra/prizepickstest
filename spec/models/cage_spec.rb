require "rails_helper"

RSpec.describe Cage, type: :model do
  let!(:diet_carnivore) { create(:diet) }
  let!(:diet_herbivore) { create(:diet, name: DIETS[:herbivore]) }

  it "baseline creation" do
    expect { create(:cage, diet: diet_carnivore) }.to change { Cage.count }.by(1)
  end

  it "cannot delete a non-empty cage" do
    cage = create(:cage, power_state: POWER_STATES[:active], diet: diet_carnivore)
    create(:dinosaur, diet: diet_carnivore, cage: cage)
    expect { cage.destroy }.to raise_exception(Storage::OccupiedCageException)
  end
end
