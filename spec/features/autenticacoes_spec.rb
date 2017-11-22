require 'rails_helper'

=begin

Autenticação no sistema

- O proprietário precisa se autenticar no sistema

Cenários

- Proprietário de loja loga no sistema
- Usuário desconhecido não tem acesso ao sistema

=end

feature "Autenticações", :type => :feature do
  
  scenario 'Proprietário de loja loga no sistema' do
    dado_existe_um_usuario_cadastrado
    e_usuario_eh_proprietario_de_uma_loja
    e_estamos_na_pagina_inicial
    quando_usuario_preencher_login_e_senha
    e_clicar_em_login
    entao_login_foi_realizado_com_sucesso
    e_usuario_foi_para_pagina_das_lojas
  end
  scenario 'Usuário desconhecido não tem acesso ao sistema' do
    dado_um_usuario_nao_cadastrado
    e_estamos_na_pagina_inicial
    quando_usuario_preencher_login_e_senha
    e_clicar_em_login
    entao_usuario_ver_mensagem_de_falha_de_login
    e_usuario_permanece_na_pagina_inicial
  end


end
