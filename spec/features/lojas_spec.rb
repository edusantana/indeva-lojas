require 'rails_helper'

=begin

Um proprietário pode possui várias lojas.

Embora os requisitos não mencionam, mas para diferenciar uma loja de outra faz-se necessário criar algum atributo em loja. Neste caso, vamos supor que as lojas possuam um nome que poderia ser preenchido com o Local ou Link, algo que identifique unicamente uma loja para o proprietário.

Um proprietário logado no sistema tem acesso às suas lojas.

Cenários

- Proprietário loga no sistema com sucesso
- Proprietário acessa sua loja
- Proprietário de lojas ver todas as suas lojas cadastradas
- Proprietário não ver lojas que não são suas
- Usuário desconhecido não tem acesso às lojas
- Proprietário não tem acesso para ver/editar/destroir lojas alheias

=end


feature "Lojas", :type => :feature do

  pending "Usuário cria uma loja (tornando-se proprietário dela)"
  
  scenario 'Proprietário loga no sistema com sucesso' do
    dado_existe_um_usuario_cadastrado
    e_usuario_eh_proprietario_de_uma_loja
    e_estamos_na_pagina_inicial
    quando_clica_em_login
    e_usuario_preencher_login_e_senha
    e_clicar_em_log_in
    entao_login_foi_realizado_com_sucesso
    e_usuario_foi_para_pagina_das_lojas
  end

  scenario 'Usuário desconhecido não tem acesso às lojas' do
    dado_um_usuario_nao_cadastrado
    e_uma_loja_e_proprietario_cadastrados
    quando_usuario_tenta_acessar_as_lojas
    entao_usuario_ver_mensagem_indicando_que_precisa_fazer_login
  end


  scenario 'Proprietário não ver lojas que não são suas' do
    dado_um_proprietario_com_uma_loja
    e_um_outro_proprietario_com_uma_loja
    quando_primeiro_proprietario_estiver_logado_na_pagina_de_lojas
    entao_ele_nao_ver_as_lojas_do_outro
  end

  pending "Proprietário não tem acesso para ver/editar/destroir lojas alheias"

  def dado_um_usuario_nao_cadastrado
    @usuario_nao_cadastrado = build(:user)
  end

  def dado_existe_um_usuario_cadastrado
    @usuario = create(:user)
  end

  def e_usuario_eh_proprietario_de_uma_loja
    @loja = create(:loja, :proprietario => @usuario)
    @proprietario = @usuario
  end

  def e_uma_loja_e_proprietario_cadastrados
    @proprietatio = create(:user)
    @loja = create(:loja, :proprietario => @proprietatio)
  end

  def dado_um_proprietario_com_uma_loja
    e_uma_loja_e_proprietario_cadastrados
  end

  def e_um_outro_proprietario_com_uma_loja
    @outro = create(:user)
    @outro_loja = create(:loja, :proprietario => @outro)
  end

  def e_estamos_na_pagina_inicial
    visit '/'
  end

  def quando_usuario_tenta_acessar_as_lojas
    visit lojas_path
  end

  def quando_primeiro_proprietario_estiver_logado_na_pagina_de_lojas
    login(@proprietatio)
    visit(lojas_path)
  end

  def quando_clica_em_login
    click_on 'Login'
  end

  def e_clicar_em_log_in
    click_on 'Log in'
  end

  def e_usuario_preencher_login_e_senha
    fill_in 'user_email', with: @usuario.email
    fill_in 'user_password', with: @usuario.password
  end

  def entao_login_foi_realizado_com_sucesso
    expect(page).to have_content('Signed in successfully.')
  end

  def entao_usuario_ver_mensagem_indicando_que_precisa_fazer_login
    expect(page).to have_content('You need to sign in or sign up before continuing.')
  end

  def e_usuario_foi_para_pagina_das_lojas
    expect(page).to have_current_path(lojas_path)    
  end

  def entao_ele_nao_ver_as_lojas_do_outro
    expect(page).not_to have_content(@outro_loja.nome)
  end

end
