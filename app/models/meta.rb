class Meta < ApplicationRecord
  belongs_to :loja
  has_many :dias

  def total_por_vendedores(vendedores)
    total = {}
    vendedores.each { |v| total[v.id] = 0}

    dias.each do |dia|
      dia.vendedores.each {|v| total[v.id] += dia.valor_dividido}
    end

    total
  end
end
