# spec/factories.rb

# This will guess the User class
FactoryBot.define do

  sequence :email do |n|
    "person#{n}@example.com"
  end
  
  sequence :nome do |n|
    "nome#{n}"
  end

  factory :user do
    email { generate(:email) }
    password "ruby123"
    password_confirmation= "ruby1234"
  end

  factory :loja do
    nome
  end

end