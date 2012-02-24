class CreateAmigoBloqueados < ActiveRecord::Migration
  def self.up
    create_table :amigo_bloqueados do |t|
      t.integer :amigo_id
      t.integer :amigo_id_bloq

      t.timestamps
    end
  end

  def self.down
    drop_table :amigo_bloqueados
  end
end
