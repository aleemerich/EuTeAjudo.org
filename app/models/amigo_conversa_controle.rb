class AmigoConversaControle < ActiveRecord::Base
  belongs_to :amigo
  belongs_to :conversa
end
