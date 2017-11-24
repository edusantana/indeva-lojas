class Dia < ApplicationRecord
  belongs_to :meta
  has_and_belongs_to_many :vendedores
  
end
