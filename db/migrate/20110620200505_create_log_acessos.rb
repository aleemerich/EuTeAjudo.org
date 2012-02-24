class CreateLogAcessos < ActiveRecord::Migration
  def self.up
    create_table :log_acessos do |t|
      t.text :ip
      t.text :email
      t.text :senha
      t.text :status

      t.timestamps
    end
  end

  def self.down
    drop_table :log_acessos
  end
end
