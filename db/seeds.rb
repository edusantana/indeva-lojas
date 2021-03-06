# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

@alice = User.create(:email => 'alice@email.com', :password => 'password', :password_confirmation => 'password')
@bob = User.create(:email => 'bob@email.com', :password => 'password', :password_confirmation => 'password')

lj_salvador = Loja.create(nome: 'Salvador', proprietario: @alice)
lj_sao_paulo = Loja.create(nome: 'São Paulo', proprietario: @alice)

lj_rio = Loja.create(nome: 'Rio de Janeiro', proprietario: @bob)
lj_recife = Loja.create(nome: 'Recife', proprietario: @bob)

meta_salvador_2017_12 = lj_salvador.metas.create(ano: 2017, mes: 12, valor: 3000.0, inicio: Date.new(2017,12,1), fim: Date.new(2017,12,31))
meta_salvador_2018_01 = lj_salvador.metas.create(ano: 2018, mes: 1, valor: 2500.0, inicio: Date.new(2018,1,1), fim: Date.new(2018,1,31))

v1 = lj_salvador.vendedores.create(nome: 'Vendedor Salv 1')
v2 = lj_salvador.vendedores.create(nome: 'Vendedor Salv 2')
v3 = lj_salvador.vendedores.create(nome: 'Vendedor Salv 3')


dia = meta_salvador_2017_12.dias.create(data: Date.new(2017,12,1), valor:250)
[v1,v2].each { |v| v.dias << dia }
dia = meta_salvador_2017_12.dias.create(data: Date.new(2017,12,2), valor:100)
[v2,v3].each { |v| v.dias << dia }
dia = meta_salvador_2017_12.dias.create(data: Date.new(2017,12,3), valor:600)
[v1,v2,v3].each { |v| v.dias << dia }
dia = meta_salvador_2017_12.dias.create(data: Date.new(2017,12,4), valor:320)
[v1,v3].each { |v| v.dias << dia }
