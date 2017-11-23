# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

@alice = User.create(:email => 'alice@email.com', :password => 'password', :password_confirmation => 'password')
@bob = User.create(:email => 'bob@email.com', :password => 'password', :password_confirmation => 'password')

@lj_salvador = Loja.create(nome: 'Salvador', proprietario: @alice)
@lj_sao_paulo = Loja.create(nome: 'São Paulo', proprietario: @alice)

@lj_rio = Loja.create(nome: 'Rio de Janeiro', proprietario: @bob)
@lj_recife = Loja.create(nome: 'Recife', proprietario: @bob)
