FactoryBot.define do
  factory :species do
    name { SecureRandom.hex }
  end
end
