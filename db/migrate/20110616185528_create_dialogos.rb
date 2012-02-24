class CreateDialogos < ActiveRecord::Migration
  def self.up
    create_table :dialogos do |t|
      t.integer :conversa_id
      t.integer :amigo_id
      t.text :texto

      t.timestamps
    end
  end

  def self.down
    drop_table :dialogos
  end
end
