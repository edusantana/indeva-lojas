class Meta < ApplicationRecord
  belongs_to :loja
  has_many :dias

  # Retorna um Hash com o total da participação dos vendedores com as vendas da meta
  def total_por_vendedores(vendedores)
    total = {}
    vendedores.each { |v| total[v.id] = 0}

    dias.each do |dia|
      dia.vendedores.each {|v| total[v.id] += dia.valor_dividido}
    end

    total
  end

  def total
    total = 0
    dias.each {|v| total += v.valor}
    total
  end
end
