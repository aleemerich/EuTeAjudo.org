# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time

  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  protect_from_forgery # :secret => '28fb28538b4cbcf195d75f2f4dfb5983'
  
  # See ActionController::Base for details 
  # Uncomment this to filter the contents of submitted sensitive data parameters
  # from your application log (in this case, all fields with names like "password"). 
  # filter_parameter_logging :password
  
  def logAcesso(ip_cliente, email_cliente, senha_cliente, status_cliente)
    @log = LogAcesso.new
    @log.ip = ip_cliente
    @log.email = email_cliente
    @log.senha = senha_cliente
    @log.status = status_cliente
    @log.save
  end

  # Sobrescrevendo uma função do sistema para mostrar erros mais amigáveis
  ActionView::Base.field_error_proc = Proc.new do |html_tag, instance|
    if instance.error_message.kind_of?(Array)
      %(#{html_tag}<span style="color:#F00">&nbsp;
        #{instance.error_message.join('|')}</span>)
    else
      %(#{html_tag}<span style="color:#F00">&nbsp;
        #{instance.error_message}</span>)
    end
  end

end
