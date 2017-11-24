# spec/factories.rb

# This will guess the User class
FactoryBot.define do

  sequence :email do |n|
    "person#{n}@example.com"
  end
  
  sequence :nome do |n|
    "nome#{n}"
  end

  factory :user, aliases: ['proprietario'] do
    email { generate(:email) }
    password "ruby123"
    password_confirmation= "ruby1234"
  end

  factory :loja do
    nome
  end

  factory :vendedor do
    nome
    loja
  end
  
  factory :meta do
    mes { Time.now.month }
    ano { Time.now.year }
    inicio { Time.now.change(:day => 1).to_date }
    fim { Time.now.change(:day => 28).to_date }
    valor { 500+(rand * 1000).round(0) }
    loja
  end

  factory :dia do
    data { Time.now.to_date }
    valor { (rand * 100).round(0) }
    meta
  end

end