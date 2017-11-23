require 'rails_helper'

RSpec.describe Loja, type: :model do
  

  it "tem um nome e proprietario" do
    proprietario = create(:user)
    loja = Loja.create(nome: 'nome qualquer', proprietario: proprietario)

    expect(loja.nome).to eq('nome qualquer')
    expect(loja.proprietario).to eq(proprietario)
  end


end
