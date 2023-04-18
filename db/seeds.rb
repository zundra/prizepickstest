class DinoSeedData
  attr_accessor :species, :diets, :dino_data
  def initialize(species, diets, dino_data)
    self.species = species
    self.diets = diets
    self.dino_data = dino_data
  end
end

def load_data
  species_list = []
  diet_list = []
  dino_data = []

  File.read("#{Rails.root}/db/data/dinosaurs.csv").each_line do |line|
    fields = line.split(",")
    name = fields[0]&.strip&.upcase_first
    next unless name
    diet = fields[1]&.strip&.upcase
    next unless diet
    species = fields[2]&.strip&.upcase
    next unless species
    species_list.push(species)
    diet_list.push(diet)
    dino_data.push(name: name, diet: diet, species: species)
  end

  species_list.uniq!
  diet_list.uniq!
  DinoSeedData.new(species_list, diet_list, dino_data)
end

def seed_db!
  data_object = load_data
  create_species!(data_object.species)
  create_diets!(data_object.diets)
  create_cages!
  create_dinosaurs!(data_object.dino_data)
end

def create_species!(species)
  ActiveRecord::Base.connection.execute("TRUNCATE species RESTART IDENTITY")
  species.each { |s| Species.create(name: s) }
end

def create_diets!(diets)
  ActiveRecord::Base.connection.execute("TRUNCATE diets RESTART IDENTITY")
  diets.each { |d| Diet.create(name: d) }
end

def create_cages!
  ActiveRecord::Base.connection.execute("TRUNCATE cages RESTART IDENTITY")
  Diet.all.each { |diet| Cage.create(diet: diet, power_state: POWER_STATES[:active]) }
end

def create_dinosaurs!(dino_data)
  ActiveRecord::Base.connection.execute("TRUNCATE dinosaurs RESTART IDENTITY")
  dino_data.each do |data|
    species = Species.where(name: data[:species]).first
    next unless species
    diet = Diet.where(name: data[:diet]).first
    next unless diet
    cage = diet.cages.first
    next unless cage
    Dinosaur.create(name: data[:name], diet: diet, cage: cage, species: species)
  end
end

seed_db!
