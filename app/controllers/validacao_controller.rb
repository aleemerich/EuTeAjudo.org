class ValidacaoController < ApplicationController
  # acesso a raiz do site "/"
  def index
    #if flash[:notice]
      #flash[:notice] = flash[:notice] + ' <br /><br /><b>ATENÇÃO! Este site está em testes. </b><br />As postagens feitas até 10/07/2011 serão deletadas. Após esse período, o site entrará em funcionamento normal.'
    #else
      #flash[:notice] = '<b>ATENÇÃO! Este site está em testes. </b><br />As postagens feitas até 10/07/2011 serão deletadas. Após esse período, o site entrará em funcionamento normal.'
    #end 
  end
  
  # efetivando a string de validação enviada ao usuário ao criar sua conta
  def new
    @amigo = Amigo.find(:first, :conditions => ['stringValidacao = ?', params[:chave]])
    if @amigo
      # analisa se essa chave já foi validada
      if @amigo.nivelPermissao > 0
        flash[:notice] = 'Falha na autenticação! Essa chave ja foi falidada. Confira o endereço WEB e tente novamente. Caso persista, entre em contato conoso na opção "QUEM SOMOS"'
        redirect_to "/"
      else
        @amigo.dataValidacao = DateTime.current()
        if !@amigo.cpf.blank? && !@amigo.telefone.blank? && !@amigo.profissao.blank?
          @amigo.nivelPermissao = 2
        else
          @amigo.nivelPermissao = 1
        end
        # Salvar as alterações
        if @amigo.save
          flash[:notice] = 'CONTA VERIFICADA COM SUCESSO! Bem vindo ao grupo de amigos do EuTeAjudo.org! Faça sua autenticação e participe de nossa comunidade.'
          redirect_to "/"
        else
          flash[:notice] = 'Falha na autenticação! Sua chave não pôde ser validada. Confira o endereço WEB e tente novamente. Caso persista, entre em contato conoso na opção "QUEM SOMOS"'
          redirect_to "/"
        end
      end
    else
      # Em caso de uma chave não ser encontrada
      flash[:notice] = 'Falha na autenticação! A chave fornecida é inválida. Confira o endereço WEB e tente novamente. Caso persista, entre em contato conoso na opção "QUEM SOMOS"'
      redirect_to "/"
    end
  end
  
  # autenticação dos usuários do site
  def autenticacao
    @amigo = Amigo.find(:first, :conditions => ["email = ? AND senha = ?", params[:email], params[:senha]])
    if @amigo
      if @amigo.statusBloqueio != 0
        logAcesso(request.remote_ip, params[:email], "xxxxxx", "Usuário bloqueado pelo statusBloqueio")
        flash[:notice] = 'Seu usuário está bloqueado! Se desconhece o motivo, por favor, em contato conoso na opção "QUEM SOMOS"'
        redirect_to "/" 
      elsif @amigo.nivelPermissao <= 0
        logAcesso(request.remote_ip, params[:email], "xxxxxx", "Usuário bloqueado pelo nivelPermissao")
        flash[:notice] = 'Seu usuário está bloqueado! Valide a chave de autenticação enviada em seu e-mail. Caso persista o problema, entre em contato conoso na opção "QUEM SOMOS"'
        redirect_to "/" 
      else
        session[:user] = @amigo
        session[:autenticado] = true
        logAcesso(request.remote_ip, params[:email], "xxxxxx", "Autenticação OK")
        redirect_to "/conversas/ajuda"
      end
    else
      if session[:tentativaErro]
        session[:tentativaErro] = 1 + session[:tentativaErro]
      else
        session[:tentativaErro] = 1
      end
      logAcesso(request.remote_ip, params[:email], params[:senha], "Erro de autenticação. (tentativa = " + session[:tentativaErro].to_s + ")")
      flash[:notice] = 'Usuário e senha não conferem! Por favor, tente novamente. Caso persista, entre em contato conoso na opção "QUEM SOMOS"'
      redirect_to "/"
    end
  end
  
  # realizando o LOGOFF dos usu�rio do site
  def logoff
    logAcesso(request.remote_ip, session[:user].email, "xxxxxx", "Encerrando autenticação")
    reset_session
    redirect_to "/"
  end
  
  # realizando o reenvio de senha
  def reenvio
     @amigo = Amigo.find(:first, :conditions => ["email = ? AND nivelPermissao > 0 AND statusBloqueio = 0", params[:email]])
    if @amigo
      @amigo.reenvioSenha += @amigo.reenvioSenha
      @amigo.save
      Mensagens.deliver_reenvioSenha(@amigo)
      logAcesso(request.remote_ip, params[:email], "xxxxxx", "Reenvio de senha OK")
      flash[:notice] = 'Um e-mail com a sua senha foi enviado! Cheque sua caixa postal.'
      redirect_to "/"
    else
      logAcesso(request.remote_ip, params[:email], "xxxxxx", "Falha no reenvio de senha")
      flash[:notice] = 'E-mail não localizado! Não foi possível reenviar a senha. Por favor, tente novamente. Caso persista, entre em contato conoso na opção "QUEM SOMOS"'
      redirect_to "/"
    end   
  end
  
  # encaminha para a página QUEM SOMOS
  def quemSomos
    
  end
end
