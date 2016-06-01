class User < ActiveRecord::Base
 
    #has_and_belongs_to_many :answered_polls, foreign_key: "user_id", class_name: "Poll"
    #has_and_belongs_to_many :interested_polls, foreign_key: "user_id", class_name: "Poll"
    has_and_belongs_to_many :answered_polls, :class_name => "Poll", :join_table => "respondents_polls", :foreign_key => "user_id"
    has_and_belongs_to_many :interesting_polls, :class_name => "Poll", :join_table => "interested_polls", :foreign_key => "user_id"
    has_one :creator_requisition_list
   
    validates_presence_of :name
    validates_presence_of :email
    validates_presence_of :cpf 
    validates_presence_of :password
    
    validates_uniqueness_of :email, message: "Email já cadastrado"
    validates_uniqueness_of :cpf, message: "Número de cpf já cadastrado"
    
    validates_format_of :email, with:/\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i, message: "Email inválido"
    validates_length_of :cpf, :is => 11, message: "O cpf deve possuir 11 dígitos"
    
    validates :cpf, cpf: true # <-- chama cpf_validator
    
end
