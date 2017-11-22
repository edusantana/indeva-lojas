class Loja < ApplicationRecord

  belongs_to :proprietario, class_name: "User"
  
end
