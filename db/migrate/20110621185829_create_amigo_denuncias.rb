class CreateAmigoDenuncias < ActiveRecord::Migration
  def self.up
    create_table :amigo_denuncias do |t|
      t.integer :amigo_id
      t.integer :amigo_id_denunciado
      t.integer :conversa_id
      t.text :texto

      t.timestamps
    end
  end

  def self.down
    drop_table :amigo_denuncias
  end
end
