Rails.application.routes.draw do
  resources :dinosaurs
  put "dinosaurs/:id/add_to_available_cage/:cage_id" => "dinosaurs#add_to_available_cage"

  resources :cages
  resources :species
end
