class AddMotivoToAmigoBloqueados < ActiveRecord::Migration
  def self.up
    add_column :amigo_bloqueados, :motivo, :text
  end

  def self.down
    remove_column :amigo_bloqueados, :motivo
  end
end
