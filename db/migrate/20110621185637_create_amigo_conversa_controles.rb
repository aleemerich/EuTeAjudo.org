class CreateAmigoConversaControles < ActiveRecord::Migration
  def self.up
    create_table :amigo_conversa_controles do |t|
      t.integer :amigo_id
      t.integer :conversa_id
      t.integer :flagBloqueio

      t.timestamps
    end
  end

  def self.down
    drop_table :amigo_conversa_controles
  end
end
