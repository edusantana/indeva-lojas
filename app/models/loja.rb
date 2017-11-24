class Loja < ApplicationRecord

  belongs_to :proprietario, class_name: "User", foreign_key: :proprietario_id
  has_many :metas
  
end
