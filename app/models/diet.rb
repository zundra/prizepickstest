class Diet < ApplicationRecord
  has_many :cages
  has_many :dinosaurs
end
