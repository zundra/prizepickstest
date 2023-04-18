require "rails_helper"

RSpec.describe Diet, type: :model do
  it "creates a dinosaur diet" do
    expect(create(:diet).name).to eql(DIETS[:carnivore])
  end
end
