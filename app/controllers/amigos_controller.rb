class AmigosController < ApplicationController
   # GET /amigos/1
  def edit
    session[:menuAtual] = request.url
    @amigo = Amigo.find(params[:id])
    render :action => "new"
  end

  # GET /amigos/new/ajuda
  def new
    if (!session[:autenticado]) and (params[:tipo] == "ajuda" or params[:tipo] == "ajudante")
      @amigo = Amigo.new
    else
      logAcesso(request.remote_ip, "xxxxxx", "xxxxxx", "[I] Controller AMIGOS|Ação NEW - Tentativa de acesso bloqueada")
      flash[:notice] = 'Sua tentativa de cadastro foi bloqueada'
      redirect_to "/"
    end
  end

  # POST /amigos
  def create
    @amigo = Amigo.new(params[:amigo])
    @amigo.stringValidacao = SecureRandom.hex(14)
    @amigo.cpf = @amigo.cpf.gsub(/[-_.,]/, '') if !@amigo.cpf.blank?
    @amigo.nivelPermissao = 0
    @amigo.reenvioSenha = 0
    @amigo.statusBloqueio = 0
    
    if @amigo.save
      if Mensagens.deliver_chaveAutenticacao(@amigo)
        logAcesso(request.remote_ip, @amigo.email, "xxxxxx", "Controller AMIGOS|Ação CREATE - Um novo amigo se cadastrou")
        flash[:notice] = '<strong>Seu cadastro foi efetuado com sucesso! Acesse seu e-mail e faça a validação de sua conta. Obrigado!</strong><br /><br />OBS: Caso demore o recebimento do e-mail, cheque seu lixo eletrônico ou sua pasta de SPAM.'      
      else
        @amigo.destroy
        logAcesso(request.remote_ip, @amigo.email, "xxxxxx", "Controller AMIGOS|Ação CREATE - Problemas ao enviar o e-mail de validação")
        flash[:notice] = 'Seu cadastro NÃO foi efetuado por problemas com o e-mail! Tente novamente mais tarde!'
      end
      redirect_to "/"
    else
      render :action => "new", :tipo => params[:tipo]
    end
  end

  # POST /amigo/update/1
  def update
    @amigo = Amigo.find(params[:id])
    if @amigo
      params[:amigo][:cpf] = params[:amigo][:cpf].gsub(/[-_.,]/, '') if !params[:amigo][:cpf].blank?
      if @amigo.update_attributes(params[:amigo])
        if @amigo.cpf.size > 0 && @amigo.telefone.size > 0 && @amigo.profissao.size > 0
          @amigo.nivelPermissao = 2
        else
          @amigo.nivelPermissao = 1
        end
        @amigo.save
        session[:user] = @amigo
        logAcesso(request.remote_ip, @amigo.email, "xxxxxx", "Controller AMIGOS|Ação UPDATE - O amigo modificou seus dados")
        flash[:notice] = 'Seus dados foram atualizados com sucesso!'
        redirect_to :action => "index", :controller => 'conversas', :tipo => "ajuda"
      else
        render :action => "new"
      end
    else
      flash[:notice] = 'O usuário não foi encontrado para ser atualizado! Entre em contato conoso na opção "QUEM SOMOS" relatando o problema'
      render :action => "new"
    end
  end

  #TODO: Criar função de congelamento de amigo
end
