FactoryBot.define do
  factory :cage do
    power_state { POWER_STATES[:down] }
  end
end
