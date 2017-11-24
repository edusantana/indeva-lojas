class Vendedor < ApplicationRecord
  belongs_to :loja
  has_and_belongs_to_many :dias
  
end
