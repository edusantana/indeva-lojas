require 'rails_helper'

RSpec.describe Meta, type: :model do

  let!(:proprietario) {create(:proprietario)}
  let!(:loja) {create(:loja, proprietario:proprietario)}

  describe '#total' do
    let(:meta) {create(:meta, loja: loja)}

    context 'sem vendas' do
      it 'Retorna 0' do
        expect(meta.total).to eq(0)
      end
    end

    context 'com vendas (dias)' do
      before do
        create(:dia, meta: meta, valor:100)
        create(:dia, meta: meta, valor: 30)
      end

      it 'retorna a soma das vendas de todos os dias da meta' do
        expect(meta.total).to eq(130)
      end
    end
  end

end
