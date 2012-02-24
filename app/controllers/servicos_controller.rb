class ServicosController < ApplicationController

  def novosPedidosAjuda
    @conversas = Conversa.find(:all,
          :conditions => ['status = 0'])
    if !@conversas.blank?
      assuntos = Array.new
      @conversas.each do |conversa|
        assuntos.push(conversa.assunto)
      end      
      @amigos = Amigo.find(:all,
          #:conditions => ['id = 33'])
          :conditions => ['nivelPermissao = 2'])
      @amigos.each do |amigo|
        begin
          Mensagens.deliver_avisoNovoPedidoAJuda(amigo, assuntos)
        rescue
          logAcesso(request.remote_ip, "Serviço de agendamento", "xxxxxx", '[I] ERRO ao enviar e-mail para amigos: ' + amigo.email)
          logger.fatal '==> ERRO ao enviar e-mail para amigos: ' + amigo.email
        end
      end
      logAcesso(request.remote_ip, "Serviço de agendamento", "xxxxxx", "Controller Servicos|Ação novosPedidosAjuda - Um e-mail com novos pedidos de ajuda foi enviado")
      render :text => @amigos.length.to_s + ' amigos avisados'
    else
      logAcesso(request.remote_ip, "Serviço de agendamento", "xxxxxx", "Controller Servicos|Ação novosPedidosAjuda - Não há novos pedidos de ajuda")
      render :text => 'N�o h� novos pedidos de ajuda'
    end
    
   
  end
end
