class AddFlagNovidadeToAmigoConversaControles < ActiveRecord::Migration
  def self.up
    add_column :amigo_conversa_controles, :flagNovidade, :integer
  end

  def self.down
    remove_column :amigo_conversa_controles, :flagNovidade
  end
end
