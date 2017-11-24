class Dia < ApplicationRecord
  belongs_to :meta
  has_and_belongs_to_many :vendedores

  def valor_dividido
    valor/vendedores.size
  end
  
end
