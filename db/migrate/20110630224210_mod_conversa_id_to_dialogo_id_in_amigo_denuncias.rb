class ModConversaIdToDialogoIdInAmigoDenuncias < ActiveRecord::Migration
  def self.up
    rename_column :amigo_denuncias, :conversa_id, :dialogo_id
  end

  def self.down
    rename_column :amigo_denuncias, :dialogo_id, :conversa_id
  end
end
