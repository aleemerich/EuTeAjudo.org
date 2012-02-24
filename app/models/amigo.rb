class Amigo < ActiveRecord::Base
  has_many :amigo_conversa_controles
  has_many :amigo_bloqueados
  has_many :dialogos
  
  validates_presence_of :nomeCompleto, :message => "O nome deve ser preenchido"
  validates_presence_of :senha, :message => "A senha deve ser preenchida"
  validates_presence_of :cidade, :message => "A cidade deve ser preenchida"
  validates_presence_of :estado, :message => "O estado deve ser preenchido"
  validates_presence_of :email, :message => "O e-mail deve ser preenchido"
  
  validates_length_of :nomeCompleto, :in => 6..250, :too_short => "Esse nome não é válido."
  validates_length_of :senha, :within => 6..250, :too_short => "A senha deve ter mais que 6 caracteres"
  validates_length_of :cidade, :in => 3..250, :too_short => "Essa cidade não é válida."
  validates_length_of :estado, :is => 2, :message => "A siga de estado deve ter 2 digitos"
  
  validates_uniqueness_of :email, 
                      :message => "Esse e-mail já está cadastrado."
  validates_format_of :email,
                        :with => /\A[\w\._%-]+@[\w\.-]+\.[a-zA-Z]{2,4}\z/,
                        :if => Proc.new { |u| !u.email.nil? && !u.email.blank? },
                        :message => "Esse e-mail não é válido."
  validates_format_of :telefone,
                      :with => /^(([0-9]{2})?(\([0-9]{2}\))([0-9]{3}|[0-9]{4})-[0-9]{4})$|^([0-9]{10})$/,
                      :if => Proc.new { |u| !u.telefone.nil? && !u.telefone.blank? },
                      :message => "Esse telefone não é válido."

  validates_length_of :profissao, :within => 6..250,
                      :if => Proc.new { |u| !u.profissao.nil? && !u.profissao.blank? },
                      :too_short => "A profissão não é válida"
  validates_uniqueness_of :cpf, 
                      :if => Proc.new { |u| !u.cpf.nil? && !u.cpf.blank? },
                      :message => "Esse CPF já está cadastrado."
  validate :cpf_of
      
  def cpf_of
    if cpf.nil? || cpf.blank?
      return true
    else  
      nulos = %w{12345678909 11111111111 22222222222 33333333333 44444444444 55555555555 66666666666 77777777777 88888888888 99999999999 00000000000}
      valor = cpf.scan /[0-9]/
      if valor.length == 11
        unless nulos.member?(valor.join)
          valor = valor.collect{|x| x.to_i}
          soma = 10*valor[0]+9*valor[1]+8*valor[2]+7*valor[3]+6*valor[4]+5*valor[5]+4*valor[6]+3*valor[7]+2*valor[8]
          soma = soma - (11 * (soma/11))
          resultado1 = (soma == 0 or soma == 1) ? 0 : 11 - soma
          if resultado1 == valor[9]
            soma = valor[0]*11+valor[1]*10+valor[2]*9+valor[3]*8+valor[4]*7+valor[5]*6+valor[6]*5+valor[7]*4+valor[8]*3+valor[9]*2
            soma = soma - (11 * (soma/11))
            resultado2 = (soma == 0 or soma == 1) ? 0 : 11 - soma
            if resultado2 == valor[10] # CPF válido
              return true
            end 
          end
        end
      end
      errors.add(:cpf, "Esse CPF não é válido.")
    end
  end   
end
