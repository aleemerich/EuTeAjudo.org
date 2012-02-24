class Mensagens < ActionMailer::Base
  def chaveAutenticacao(amigo)
    @subject = "[EuTeAjudo.org] Confirmação de Cadastro"
    @recipients = amigo.email
    @from = 'no-reply@euteajudo.org'
    @sent_on = Time.now
    @body["nomeCompleto"] = amigo.nomeCompleto
    @body["id"] = amigo.id
    @body["stringValidacao"] = amigo.stringValidacao
    @headers = {content_type => 'text/html'}
  end
  
  def reenvioSenha(amigo)
    @subject = "[EuTeAjudo.org] Reenvio de senha"
    @recipients = amigo.email
    @from = 'no-reply@euteajudo.org'
    @sent_on = Time.now
    @body["senha"] = amigo.senha
    @headers = {content_type => 'text/html'}
  end
  
  def avisoPostagem(amigo, conversa)
    @subject = "[EuTeAjudo.org] Novas postagens"
    @recipients = amigo.email
    @from = 'no-reply@euteajudo.org'
    @sent_on = Time.now
    @body["amigoNomeCompleto"] = amigo.nomeCompleto
    @body["conversaAssunto"] = conversa.assunto
    @headers = {content_type => 'text/html'}
  end
  
  def avisoBloqueio(amigo, motivo, id_do_amigo)
    @subject = "[EuTeAjudo.org] Você foi bloqueado"
    @recipients = amigo.email
    @from = 'no-reply@euteajudo.org'
    @sent_on = Time.now
    @body["amigoNomeCompleto"] = amigo.nomeCompleto
    @body["id_do_amigo"] = id_do_amigo
    @body["motivo"] = motivo
    @headers = {content_type => 'text/html'}
  end
  
  def avisoDesbloqueio(amigo, id_do_amigo)
    @subject = "[EuTeAjudo.org] Você foi desbloqueado"
    @recipients = amigo.email
    @from = 'no-reply@euteajudo.org'
    @sent_on = Time.now
    @body["amigoNomeCompleto"] = amigo.nomeCompleto
    @body["id_do_amigo"] = id_do_amigo
    @headers = {content_type => 'text/html'}
  end
  
  def avisoDenuncia(amigo_id, amigo_id_d, dialogo, texto)
    @subject = "[Denúncia] Uma denúncia foi feita!"
    @recipients = 'suporte@euteajudo.org'
    @from = 'no-reply@euteajudo.org'
    @sent_on = Time.now
    @body["amigo"] = amigo_id
    @body["amigoD"] = amigo_id_d
    @body["dialogoT"] = dialogo.texto
    @body["texto"] = texto
    @headers = {content_type => 'text/html'}
  end
  
  def avisoNovoPedidoAJuda(amigo, assuntos)
    @subject = "[EuTeAjudo.org] Há amigos precisando de sua ajuda"
    @recipients = amigo.email
    @from = 'no-reply@euteajudo.org'
    @sent_on = Time.now
    @body["amigoNomeCompleto"] = amigo.nomeCompleto
    @body["conversaAssuntos"] = assuntos
    @headers = {content_type => 'text/html'}
  end
end
