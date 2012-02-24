ActionController::Routing::Routes.draw do |map|
  # ========================================
  # PÁGINA PRINCIPAL
  # ========================================
  
  # página de entrada do site
  map.root :controller => "validacao", :action => "index"

  # ========================================
  # AUTENTICAÇÃO
  # ========================================
  
  # valida a chave de confirmação de e-mail
  map.connect "validacao/:chave", :controller => "validacao", :action => "new"
  # faz o LOGOFF do usuário
  map.connect "logoff", :controller => "validacao", :action => "logoff"
  # autentica o usuário
  map.connect "autenticacao", :controller => "validacao", :action => "autenticacao"
  # autentica o usuário
  map.connect "reenvio", :controller => "validacao", :action => "reenvio"
  # institucional
  map.connect "quemsomos", :controller => "validacao", :action => "quemSomos"  
  
  # ========================================
  # AMIGOS
  # ========================================
  
  # Formulário de Cadastro do Usuário
  map.connect "amigo/new/:tipo", :controller => "amigos", :action => "create", :conditions => { :method => :post }
  map.amigos "amigo/new/:tipo", :controller => "amigos", :action => "new"
  # Atualização do cadastro do usuário
  map.amigo "amigo/update/:id", :controller => "amigos", :action => "update", :conditions => { :method => :put }
  # Exibição dos dados para atualização do cadastro do usuário
  map.connect "amigo/:id", :controller => "amigos", :action => "edit"

  # ========================================
  # CONVERSAS
  # ========================================

  # Mostra as novas conversas para que os amigos possam ajudar
  map.connect "conversas/help/:proxPag", :controller => "conversas", :action => "helping"  
  # Exibe detalhes de uma conversa
  map.connect "conversas/:tipo", :controller => "conversas", :action => "index"
  # Página principal do sistema onde se exibe as conversas do usuário 
  map.connect "conversa/new", :controller => "conversas", :action => "new"  
  # Encerra uma conversa
  map.connect "conversa/close/:idConversa", :controller => "conversas", :action => "close"
  # Abre novamente uma conversa
  map.connect "conversa/open/:idConversa", :controller => "conversas", :action => "open"
  # Sai de uma conversa
  map.connect "conversa/exit/:idConversa", :controller => "conversas", :action => "exit"
  # Denuncia um amigo
  map.connect "conversa/denounce/:idDialogo/:idAmigo", :controller => "conversas", :action => "denounce"#, :conditions => { :method => :post }
  # Bloqueia um amigo
  map.connect "conversa/block/:idAmigo", :controller => "conversas", :action => "block"
  # Ativa a escolha de ajudar numa conversa, quando essa é selecionada por um amigo
  map.connect "conversa/help/:idConversa", :controller => "conversas", :action => "help"
  # Cria-se o espaço para nova conversa
  map.connect "conversa/:idConversa", :controller => "conversas", :action => "update", :conditions => { :method => :post }
  # Exibe detalhes de uma conversa
  map.connect "conversa/:idConversa", :controller => "conversas", :action => "show"
  # Bloqueia a entrada de novos amigos nessa conversa
  map.connect "conversa/blockHelp/:idConversa", :controller => "conversas", :action => "blockHelp"
  # Cria-se uma nova conversa no sistema
  map.connect "conversa", :controller => "conversas", :action => "create", :conditions => { :method => :post }
  
  # ========================================
  # AGENDAMENTOS
  # ========================================

  # Executa verificação de novos pedidos de ajuda
  map.connect "cron/novosPedidosAjuda", :controller => "servicos", :action => "novosPedidosAjuda"  
end
