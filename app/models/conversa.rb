class Conversa < ActiveRecord::Base
  has_many :dialogos
  has_many :amigo_conversa_controles
  
  validates_length_of :assunto, :in => 6..250, :too_short => "Você precisa inserir um ASSUNTO com mais de 6 caracteres."
end
