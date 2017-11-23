class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  
  has_many :lojas, :foreign_key => :proprietario_id


  Class User
  has_many :assignments,  :foreign_key => :contractor_id
  has_many :projects, :through => :assignments 
  
end
