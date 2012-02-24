class RemoveFlagBloqueioToAmigoConversaControles < ActiveRecord::Migration
  def self.up
    remove_column :amigo_conversa_controles, :flagBloqueio
  end

  def self.down
    add_column :amigo_conversa_controles, :flagBloqueio, :integer
  end
end
