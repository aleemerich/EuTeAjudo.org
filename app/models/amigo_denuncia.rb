class AmigoDenuncia < ActiveRecord::Base
  has_many :dialogos
  has_many :amigos
  
  validates_presence_of :dialogo_id, :message => ""
  validates_presence_of :amigo_id, :message => ""
  validates_presence_of :amigo_id_denunciado, :message => ""
  validates_presence_of :texto, :message => ""
end
