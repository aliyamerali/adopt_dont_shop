# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

Pet.destroy_all
Shelter.destroy_all
Veterinarian.destroy_all
VeterinaryOffice.destroy_all

shelter1 = Shelter.create!(name: "Denver Animal Rescue", city: "Denver", rank: 1, foster_program: true)
shelter2 = Shelter.create!(name: "Boulder Shelter", city: "Boulder", rank: 2, foster_program: false)
shelter3 = Shelter.create!(name: "Fort Collins Pets", city: "Fort Collins", rank: 3, foster_program: true)

pet1 = shelter1.pets.create!(name: "Linus", breed: "Pitbull", age: 3, adoptable: true)
pet2 = shelter1.pets.create!(name: "Dorothy", breed: "Tabby", age: 4, adoptable: true)
pet3 = shelter1.pets.create!(name: "Rufus", breed: "Lab Mix", age: 2, adoptable: true)

pet4 = shelter2.pets.create!(name: "Lincoln", breed: "Chihuahua", age: 6, adoptable: true)
pet5 = shelter2.pets.create!(name: "Madison", breed: "Main Coon", age: 1, adoptable: true)
pet6 = shelter2.pets.create!(name: "Monroe", breed: "Dachshund", age: 2, adoptable: true)

pet7 = shelter3.pets.create!(name: "Simon", breed: "Rotweiler", age: 6, adoptable: true)
pet8 = shelter3.pets.create!(name: "Chase", breed: "Scottish Fold", age: 1, adoptable: true)
pet9 = shelter3.pets.create!(name: "Lady", breed: "Doberman", age: 2, adoptable: true)

vet_office1 = VeterinaryOffice.create!(name: "Denver Petcare", boarding_services: true, max_patient_capacity: 75)
vet_office2 = VeterinaryOffice.create!(name: "Pets of Boulder", boarding_services: true, max_patient_capacity: 60)
vet_office3 = VeterinaryOffice.create!(name: "FC Animals", boarding_services: false, max_patient_capacity: 30)

vet_office1.veterinarians.create!(name: "Dr. Dana", on_call: true, review_rating: 2.4)
vet_office1.veterinarians.create!(name: "Dr. Sal", on_call: false, review_rating: 3.6)

vet_office2.veterinarians.create!(name: "Doc Whitman", on_call: false, review_rating: 4.0)
vet_office2.veterinarians.create!(name: "Dr. Mickey", on_call: true, review_rating: 3.8)

vet_office3.veterinarians.create!(name: "Dr. Dre", on_call: false, review_rating: 4.5)
vet_office3.veterinarians.create!(name: "Dr. Pepper", on_call: false, review_rating: 2.2)


application1 = Application.create!(name: "Aliya",
                                  street_address: "2525 Broad Street",
                                  city: "Denver",
                                  state: "CO",
                                  zip_code: 80218,
                                  description: "I love animals!",
                                  status: "Pending")
application2 = Application.create!(name: "Zahra",
                                  street_address: "1000 Park Avenue",
                                  city: "Longmont",
                                  state: "CO",
                                  zip_code: 80503,
                                  description: "I've got a big backyard!",
                                  status: "Pending")

ApplicationsPet.create!(pet: pet1, application: application1)
ApplicationsPet.create!(pet: pet2, application: application1)
ApplicationsPet.create!(pet: pet2, application: application2)
ApplicationsPet.create!(pet: pet3, application: application2)
