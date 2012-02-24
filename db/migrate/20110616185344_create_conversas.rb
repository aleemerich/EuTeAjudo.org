class CreateConversas < ActiveRecord::Migration
  def self.up
    create_table :conversas do |t|
      t.string :assunto
      t.integer :amigo_id
      t.integer :flagColaboracaoUnica
      t.integer :status

      t.timestamps
    end
  end

  def self.down
    drop_table :conversas
  end
end
