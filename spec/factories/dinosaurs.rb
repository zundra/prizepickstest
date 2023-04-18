FactoryBot.define do
  factory :dinosaur do
    name { SecureRandom.hex }
    species { create(:species) }
  end
end
