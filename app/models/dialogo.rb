class Dialogo < ActiveRecord::Base
  belongs_to :conversa
  belongs_to :amigo
  belongs_to :amigo_bloqueados
  
  validates_presence_of :amigo_id, :message => "Erro inesperado! O sistem não conseguiu gravar sua postagem (erro=amigo_id null)."
  validates_presence_of :conversa_id, :message => "Erro inesperado! O sistem não conseguiu gravar sua postagem (erro=conversa_id null)."
  validates_presence_of :texto, :message => "Um texto deve ser digitado <br>"
end
