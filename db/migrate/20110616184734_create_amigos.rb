class CreateAmigos < ActiveRecord::Migration
  def self.up
    create_table :amigos do |t|
      t.string :nomeCompleto
      t.string :email
      t.string :senha
      t.string :cidade
      t.string :estado
      t.string :cpf
      t.string :telefone
      t.string :profissao
      t.integer :nivelPermissao
      t.string :stringValidacao
      t.datetime :dataValidacao
      t.integer :reenvioSenha
      t.integer :statusBloqueio
      t.integer :flagAvisos

      t.timestamps
    end
  end

  def self.down
    drop_table :amigos
  end
end
