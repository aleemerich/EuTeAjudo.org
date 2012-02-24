class ConversasController < ApplicationController
  before_filter :validacao
  before_filter :validacaoOwner, :only => [:blockHelp, :open, :close]
  before_filter :validacaoNotOwner, :only => [:exit]
  before_filter :validacaoParticipate, :only => [:show, :update]
  
  # GET /conversas/ajuda
  def index
    session[:menuAtual] = request.env['PATH_INFO']
    if params[:tipo] == "ajuda"
      @conversas = Conversa.find(:all,
         :select => 'DISTINCT conversas.*, amigo_conversa_controles.flagNovidade', 
         :order => 'conversas.status DESC, conversas.updated_at DESC', 
         :joins => 'INNER JOIN amigo_conversa_controles on amigo_conversa_controles.conversa_id = conversas.id 
                    AND amigo_conversa_controles.amigo_id = %s' % [session[:user].id, session[:user].id], 
         :conditions => ['conversas.amigo_id = ? and conversas.status <> 2', session[:user].id])
      @conversasEncerradas = Conversa.find(:all, :order => 'updated_at DESC',
         :conditions => ['amigo_id = ? and status = 2', session[:user].id])
      @amigosBloqueados = AmigoBloqueado.find(:all, 
         :conditions => ['amigo_id = ?', session[:user].id])
    elsif params[:tipo] == "apoio"
      if session[:user].nivelPermissao != 2
       flash[:notice] = '<b>Ajudar um amigo é coisa muito séria!!!</b><br /><br /> Palavras erradas podem levar pessoas a fazerem coisas horríveis com a própria vida, então pense bem na responsabilidade que irá assumir ao ajudar um amigo. Isso tem que ser feito com muito <b> AMOR e CARINHO</b>. Se você tem essa consciência e quer ajudar de coração, precisa preencher os dados "CPF, Telefone e Profissão" na área "Dados Pessoais". Isso é necessário para mantermos a seriedade do site. Por favor, vá até "Dados Pessoais" e faça sua atualização.'
       redirect_to :action => "index", :tipo => "ajuda"          
      end
      @conversasApoio = Conversa.find(:all,
        :select => 'DISTINCT conversas.*, amigo_conversa_controles.flagNovidade',
        :order => 'conversas.status DESC', 
        :joins => 'INNER JOIN amigo_conversa_controles on amigo_conversa_controles.conversa_id = conversas.id 
                   AND amigo_conversa_controles.conversa_id not in (SELECT id FROM conversas WHERE amigo_id = %s)
                   AND amigo_conversa_controles.amigo_id = %s' % [session[:user].id, session[:user].id], 
        :conditions => ['conversas.status <> 2', session[:user].id])
      @conversasApoioEncerradas = Conversa.find(:all, 
        :select => 'DISTINCT conversas.*',
        :joins => 'INNER JOIN amigo_conversa_controles on amigo_conversa_controles.conversa_id = conversas.id 
                   AND amigo_conversa_controles.conversa_id not in (SELECT id FROM conversas WHERE amigo_id = %s)
                   AND amigo_conversa_controles.amigo_id = %s' % [session[:user].id, session[:user].id], 
        :conditions => ['conversas.status = 2', session[:user].id])
    else
       logAcesso(request.remote_ip, session[:user].email, "xxxxxx", "[I]Controller CONVERSAS|Ação INDEX - Tentativa de visualização fora do padrão ("+ request.env['PATH_INFO'] +")")
       flash[:notice] = 'Você tentou acessar uma página inválida.'
       redirect_to "/"      
    end
  end

  # GET /conversa/1
  def show
    @conversa = Conversa.find(:first, :conditions => ['conversas.id = ?', params[:idConversa]])
    if @conversa
      aux = AmigoBloqueado.exists?(:amigo_id => @conversa.amigo_id, :amigo_id_bloq => session[:user].id)
      if AmigoBloqueado.exists?(:amigo_id => @conversa.amigo_id, :amigo_id_bloq => session[:user].id)
        flash[:notice] = 'Você está bloqueado para conversas com esse amigo'
        redirect_to session[:menuAtual]
      else
        bd = ActiveRecord::Base.connection
        @dialogos = bd.select_all  "SELECT dialogos.id, dialogos.conversa_id, dialogos.amigo_id, dialogos.texto, dialogos.created_at, 
        dialogos.updated_at, amigo_bloqueados.id 'flagBloqueioGeral'
        FROM dialogos 
        INNER JOIN conversas ON conversas.id = dialogos.conversa_id 
        LEFT JOIN amigo_conversa_controles ON amigo_conversa_controles.conversa_id = dialogos.conversa_id 
            AND amigo_conversa_controles.amigo_id = dialogos.amigo_id 
        LEFT JOIN amigo_bloqueados ON amigo_bloqueados.amigo_id = " + session[:user].id.to_s + 
          " AND amigo_bloqueados.amigo_id_bloq = dialogos.amigo_id 
        WHERE dialogos.conversa_id = " + @conversa.id.to_s + " 
        ORDER BY dialogos.created_at DESC"
        @amigoConversa = AmigoConversaControle.find(:first, :conditions => ['conversa_id = ? AND amigo_id = ?', params[:idConversa], session[:user].id])
        @amigoConversa.flagNovidade = 0;
        @amigoConversa.save
      end
    else
      logAcesso(request.remote_ip, session[:user].email, "xxxxxx", "[I]Controller CONVERSAS|Ação SHOW - Tentativa de acesso a uma conversa fora do padrão ("+ request.env['PATH_INFO'] +")")
      flash[:notice] = 'Problemas ao acessar a CONVERSA selecionada! Tente novamente e, caso persista o problema, entre em contato conoso na opção "QUEM SOMOS"'
      redirect_to session[:menuAtual]
    end
  end

  # GET /conversa/new
  def new
    @conversa = Conversa.new
    @dialogo = Dialogo.new
  end

  # POST /conversa
  def create
    #criando uma conversa
    @conversa = Conversa.new(params[:conversa])
    @conversa.status = 0

    if @conversa.save
      #criando um dialogo da conversa criada
      @dialogo = Dialogo.new(params[:dialogo])
      @dialogo.conversa_id = @conversa.id
      @dialogo.amigo_id = @conversa.amigo_id 
      if @dialogo.save
        #atualizando a tabela de relacionamento e controle
        @amigo_conversa_controle = AmigoConversaControle.new
        @amigo_conversa_controle.amigo_id = @conversa.amigo_id
        @amigo_conversa_controle.conversa_id = @conversa.id
        @amigo_conversa_controle.save
        #levando o usuario a pagina principal
        logAcesso(request.remote_ip, session[:user].email, "xxxxxx", "CONVERSA criada")
        flash[:notice] = 'Sua conversa foi criada com sucesso!'
        redirect_to session[:menuAtual]
      else
        @conversa.destroy
        logAcesso(request.remote_ip, session[:user].email, "xxxxxx", "[I]Controller CONVERSAS|Ação CREATE - Erro ao inserir um Dialogo numa nova Conversa ("+ request.env['PATH_INFO'] +")")
        flash[:notice] = 'Houve problemas ao criar seu pedido de ajuda. Cheque se não há informações faltantes. Se o erro persistir entre em contato conoso na opção "QUEM SOMOS"'
        render :action => "new"
      end
    else 
      logAcesso(request.remote_ip, session[:user].email, "xxxxxx", "[I]Controller CONVERSAS|Ação CREATE - Erro ao inserir uma nova Conversa ("+ request.env['PATH_INFO'] +")")
      flash[:notice] = 'Houve problemas ao criar seu pedido de ajuda. Cheque se não há informações faltantes. Se o erro persistir entre em contato conoso na opção "QUEM SOMOS"'
      render :action => "new"
    end
  end

  # POST /conversa/1
  def update
    @dialogo = Dialogo.new(params[:dialogo])
    if @dialogo.save
      notificarNovidades
      flash[:notice] = 'Sua postagem foi gravada com sucesso!'
      redirect_to session[:menuAtual]
    else
      flash[:notice] = 'Você não pode enviar comentários em branco!'
      redirect_to :action => "show"
    end
  end
  
  # GET conversas/help/2
  def helping
    @conversa = Conversa.find(:first,
       :select => 'DISTINCT conversas.*',
       :order => 'status ASC',
       :offset => params[:proxPag], 
       :joins => 'INNER JOIN amigo_conversa_controles on amigo_conversa_controles.conversa_id = conversas.id 
                  AND amigo_conversa_controles.conversa_id not in (SELECT id FROM conversas WHERE amigo_id = %s)
                  AND amigo_conversa_controles.conversa_id not in (SELECT conversa_id FROM amigo_conversa_controles WHERE amigo_id = %s)
                  AND amigo_conversa_controles.amigo_id not in (%s)' % [session[:user].id, session[:user].id, session[:user].id],
       :conditions => ['((conversas.status IN (0, 1) AND conversas.flagColaboracaoUnica = 0)
                        OR (conversas.status = 0 AND conversas.flagColaboracaoUnica = 1))
                        AND (conversas.amigo_id NOT IN (SELECT amigo_id FROM amigo_bloqueados WHERE amigo_id_bloq = ?))', session[:user].id])
    if @conversa
      @dialogos = Dialogo.find(:all, 
        :order => 'created_at DESC',
        :conditions => ['conversa_id = ?', @conversa.id])
      @proxPag = params[:proxPag].to_i + 1
    else
      flash[:notice] = 'Não há mais pedidos de ajuda disponíveis.'
      redirect_to session[:menuAtual]      
    end
  end
  
  # GET conversa/help/33
  def help
    # essa análise testa:
    # 1 - se a conversa existe
    # 2 - checa se o amigo que está se inserindo nela já não está inscrito
    # 3 - Checa se ela pode aceitar qualquer amigo (flagColaboracaoUnica = 0) ou se
    #     se flagColaboracaoUnica = 1 ela vai permitir somente se niguém estiver na conversa 
    #     alem do criador (status = 0) 
    if Conversa.exists?(params[:idConversa]) and
      (!AmigoConversaControle.find(:first, :conditions => ['conversa_id = ? AND amigo_id = ?', params[:idConversa], session[:user].id])) and
      ( ((Conversa.find(:first, :conditions => ['id = ?', params[:idConversa]]).status == 0) and (Conversa.find(:first, :conditions => ['id = ?', params[:idConversa]]).flagColaboracaoUnica == 1)) or (Conversa.find(:first, :conditions => ['id = ?', params[:idConversa]]).flagColaboracaoUnica == 0)  )
      
      @controle = AmigoConversaControle.new
      @controle.amigo_id = session[:user].id
      @controle.conversa_id = params[:idConversa]
      
      # É preciso atualizar o status da conversa porque se alguém já está ajudando
      # ela não é mais uma conversa nova (status = 0)
      @conversa = Conversa.find(@controle.conversa_id)
      @conversa.status = 1
      
      if @controle.save and @conversa.save
        @dialogo = Dialogo.new
        @dialogo.amigo_id = session[:user].id
        @dialogo.conversa_id = params[:idConversa]
        @dialogo.texto = "<b>[Menssagem automática]</b> O amigo#{session[:user].id} agora está nessa conversa."
        @dialogo.save
        #Mensagens.deliver_
        redirect_to :action => "show", :idConversa => @controle.conversa_id
      else
        logAcesso(request.remote_ip, session[:user].email, "xxxxxx", "[I]Controller CONVERSAS|Ação HELP - Erro na tabela AMIGO_CONVERSA_CONTROLES ou na tabela CONVERSA ("+ request.env['PATH_INFO'] +")")
        flash[:notice] = 'Não foi possível adicioná-lo na conversa escolhida. Se o erro persistir entre em contato conoso na opção "QUEM SOMOS"'
        redirect_to session[:menuAtual]
      end
    else
      logAcesso(request.remote_ip, session[:user].email, "xxxxxx", "[I]Controller CONVERSAS|Ação HELP - Tentativa de ajudar conversa frustada ("+ request.env['PATH_INFO'] +")")
      flash[:notice] = 'A conversa que escolheu não existe ou você não pode ingressar nela!'
      redirect_to session[:menuAtual]
    end
  end
  
  # GET  /conversa/close/1
  def close
    @conversa = Conversa.find(params[:idConversa])
    if @conversa
        @conversa.status = 2
        @conversa.save
        @dialogo = Dialogo.new
        @dialogo.amigo_id = session[:user].id
        @dialogo.conversa_id = params[:idConversa]
        @dialogo.texto = "<b>[Menssagem automática]</b> Esta conversa foi encerrada."
        @dialogo.save
        redirect_to session[:menuAtual] 
    else
      logAcesso(request.remote_ip, session[:user].email, "xxxxxx", "[I]Controller CONVERSAS|Ação CLOSE - Encerramento de conversa que não existe ("+ request.env['PATH_INFO'] +")")
      flash[:notice] = 'A conversa informada não existe!'
      redirect_to session[:menuAtual]
    end
  end

  # GET  /conversa/open/1
  def open
    @conversa = Conversa.find(params[:idConversa])
    if @conversa
        if AmigoConversaControle.find(:all, :conditions => ['conversa_id = ?', params[:idConversa]]).size < 2
          @conversa.status = 0
        else
          @conversa.status = 1
        end
        @conversa.save
        @dialogo = Dialogo.new
        @dialogo.amigo_id = session[:user].id
        @dialogo.conversa_id = params[:idConversa]
        @dialogo.texto = "<b>[Menssagem automática]</b> Esta conversa foi aberta novamente."
        @dialogo.save
        redirect_to session[:menuAtual] 
    else
      logAcesso(request.remote_ip, session[:user].email, "xxxxxx", "[I]Controller CONVERSAS|Ação CLOSE - Ativação de conversa que não existe ("+ request.env['PATH_INFO'] +")")
      flash[:notice] = 'A conversa informada não existe!'
      redirect_to session[:menuAtual]
    end
  end
  
  # GET  /conversa/exit/1
  def exit
    @amigoConversa = AmigoConversaControle.find(:first, :conditions => ['conversa_id = ? AND amigo_id = ?', params[:idConversa], session[:user].id])
    if @amigoConversa
      @amigoConversa.destroy
      # Essa análise é para impedir que uma conversa fique sem amigos para apoio, uma vez que se o flagColaboracaoUnica for 1 
      # e o status não for zero, nunca um amigo verá essa conversa para ajudar, mesmo que ela só tenha o amigo que a criou
      if AmigoConversaControle.find(:all, :conditions => ['conversa_id = ?', params[:idConversa]]).size < 2
        @conversa = Conversa.find(params[:idConversa])
        @conversa.status = 0
        @conversa.save
      end
      @dialogo = Dialogo.new
      @dialogo.amigo_id = session[:user].id
      @dialogo.conversa_id = params[:idConversa]
      @dialogo.texto = "<b>[Menssagem automática]</b> O amigo#{session[:user].id} deixou essa conversa."
      @dialogo.save
      redirect_to session[:menuAtual]
    else
      logAcesso(request.remote_ip, session[:user].email, "xxxxxx", "[I]Controller CONVERSAS|Ação EXIT - Solicitação de saída da conversa incorreta ("+ request.env['PATH_INFO'] +")")
      flash[:notice] = 'Essa convesa não existe ou você não faz parte dela!'
      redirect_to session[:menuAtual]
    end
  end
  
  # POST conversa/denounce/22/33
  def denounce
    @denuncia = AmigoDenuncia.new
    @denuncia.amigo_id = session[:user].id
    @denuncia.amigo_id_denunciado = params[:idAmigo]
    @denuncia.dialogo_id = params[:idDialogo]
    @denuncia.texto = params[:texto]
    if @denuncia.save
      Mensagens.deliver_avisoDenuncia(@denuncia.amigo_id, @denuncia.amigo_id_denunciado, Dialogo.find(@denuncia.dialogo_id), @denuncia.texto)
      head :ok
    else
      head 400
    end
  end

  # POST conversa/block/22
  def block
    @amigoBloqueado = AmigoBloqueado.find(:first, :conditions => ['amigo_id = ? AND amigo_id_bloq = ?', session[:user].id, params[:idAmigo]])
    if @amigoBloqueado
      @amigoBloqueado.destroy
      flash[:notice] = 'O amigo foi desbloqueado com sucesso'
      Mensagens.deliver_avisoDesbloqueio(Amigo.find(params[:idAmigo]), session[:user].id)
      redirect_to session[:menuAtual]
    else
      @amigoBloqueado = AmigoBloqueado.new
      @amigoBloqueado.amigo_id = session[:user].id
      @amigoBloqueado.amigo_id_bloq = params[:idAmigo]
      @amigoBloqueado.motivo = params[:texto]
      @amigoBloqueado.save
      @amigoConversaOut = AmigoConversaControle.find(:all, 
             :joins => 'INNER JOIN conversas on conversas.id = amigo_conversa_controles.conversa_id
                        AND conversas.amigo_id = %s' % [session[:user].id],
             :conditions => ['amigo_conversa_controles.amigo_id = ?', params[:idAmigo]])
      @amigoConversaOut.each do |registro|
        @dialogo = Dialogo.new
        @dialogo.amigo_id = registro.amigo_id
        @dialogo.conversa_id = registro.conversa_id
        @dialogo.texto = "<b>[Menssagem automática]</b> O amigo#{registro.amigo_id} deixou essa conversa."
        @dialogo.save
        registro.destroy
      end
      Mensagens.deliver_avisoBloqueio(Amigo.find(params[:idAmigo]), params[:texto], session[:user].id)
      head :ok
    end
  end
  
  # GET conversa/blockHelp/36
  def blockHelp
    @conversa = Conversa.find(params[:idConversa])
    if @conversa
      @dialogo = Dialogo.new
      @dialogo.amigo_id = session[:user].id
      @dialogo.conversa_id = params[:idConversa]
      if @conversa.flagColaboracaoUnica == 0
        @conversa.flagColaboracaoUnica = 1
        @dialogo.texto = "<b>[Menssagem automática]</b> Esta conversa está restrita apenas aos participantes atuais ou a apenas um amigo se ainda não tiver nenhum amigo participando."
      else
        @conversa.flagColaboracaoUnica = 0
        @dialogo.texto = "<b>[Menssagem automática]</b> Esta conversa foi liberada para a participação de outros amigos."
      end
      @conversa.save
      @dialogo.save
      head :ok
    else
      head :error
    end
  end
  
  
  # ===============
  #    APOIO
  # ===============
  
  def notificarNovidades
    @amigosConversa = AmigoConversaControle.find(:all, :conditions => ['conversa_id = ?', params[:idConversa]])
    # analisa se encontrou algo
    if @amigosConversa
      # faz o loop em todos os amigos
      @amigosConversa.each do |amigoConversa|
        # analisa se o amigo em questão é o usuário atual 
        # (não se deve mandar msg pra o usuário que está gerando a novidade)
        if amigoConversa.amigo_id != session[:user].id
          amigoConversa.flagNovidade = 1
          amigoConversa.save
          # se o amigo em questão quer receber notificação...
          if Amigo.find(amigoConversa.amigo_id).flagAvisos == 1
            begin
              Mensagens.deliver_avisoPostagem(Amigo.find(amigoConversa.amigo_id), Conversa.find(amigoConversa.conversa_id))
            rescue
              logger.fatal '==> CONVERSA => UPDATE = ERRO ao enviar e-mail para um amigo: ' + Amigo.find(amigoConversa.amigo_id).email  
            end
          end
        end
      end
    end
  end
  
  # ===============
  #   VALIDAÇÃO
  # ===============
  
  protected

  def validacao
    if session[:autenticado]
      true
    else
      logAcesso(request.remote_ip, "xxxxxx", "xxxxxx", "[I]Controller CONVERSAS|Ação VALIDACAO - Tentativa de acesso frustada ("+ request.env['PATH_INFO'] +")")
      flash[:notice] = 'Você não está autenticado! Por favor, faça sua autenticação.'
      redirect_to "/"
    end
  end
  
  def validacaoOwner
    if params[:idConversa] and (Conversa.find(params[:idConversa]).amigo_id == session[:user].id)
      true
    else
      logAcesso(request.remote_ip, session[:user].email, "xxxxxx", "[I]Controller CONVERSAS|Validação validacaoOwner - Acesso negado por não ser o proprietário da conversa para alterá-la (path utilizado = "+ request.env['PATH_INFO'] +")")
      flash[:notice] = 'Você não tem autorização para acessar essa URL. Seu IP ' + request.remote_ip + ' foi armazenado para verificação futura. Ações danosas terão sua conta BLOQUEADA/SUSPENSA.'
      redirect_to session[:menuAtual]
    end
  end
  
  def validacaoNotOwner
    if params[:idConversa] and (Conversa.find(params[:idConversa]).amigo_id != session[:user].id)
      true
    else
      logAcesso(request.remote_ip, session[:user].email, "xxxxxx", "[I]Controller CONVERSAS|Validação validacaoNotOwner - Acesso negado por não ser o proprietário da conversa para alterá-la (path utilizado = "+ request.env['PATH_INFO'] +")")
      flash[:notice] = 'Você é o dono da conversa e não tem autorização para acessar essa URL. Seu IP ' + request.remote_ip + ' foi armazenado para verificação futura. Ações danosas terão sua conta BLOQUEADA/SUSPENSA.'
      redirect_to session[:menuAtual]
    end
  end
  
  def validacaoParticipate
    if AmigoConversaControle.find(:first, :conditions => ['conversa_id = ? AND amigo_id = ?', params[:idConversa], session[:user].id])
      true
    else
      logAcesso(request.remote_ip, session[:user].email, "xxxxxx", "[I]Controller CONVERSAS|Validação validacaoNotOwner - Acesso negado por não ser o proprietário da conversa para alterá-la (path utilizado = "+ request.env['PATH_INFO'] +")")
      flash[:notice] = 'Você não participa da conversa. Seu IP ' + request.remote_ip + ' foi armazenado para verificação futura. Ações danosas terão sua conta BLOQUEADA/SUSPENSA.'
      redirect_to session[:menuAtual]
    end
  end
end
