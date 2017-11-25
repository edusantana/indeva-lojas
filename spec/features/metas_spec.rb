require 'rails_helper'

=begin

Metas
- Os vendedores possuem metas de vendas por período.
- Meta possui data de início, data de fim, mês e ano de referência e valor
- Uma meta é subdividida nos dias compreendidos entre o início e fim, ou seja, cada dia do período da meta possui um valor e cada dia pode ter um valor diferente
- O somatório dos valores dos dias deve ser igual ao valor total da meta
- Cada dia deve informar quais vendedores participam e o valor será dividido igualmente entre eles
- Um dia pode pertencer apenas a uma meta, ou seja, não podem haver metas de uma mesma loja que compartilhem os mesmos dias

Exemplos

Meta 01/2017
- Inicio 02/01/2017
- Fim 03/01/2017
- Valor 1000,00

Dia 02/01/2017
  - Valor 400,00
  - Vendedores: John e Peter (R$ 200,00 para cada)

Dia 03/01/2017 
  - Valor 600,00
  - Vendedores: James, Richard, Maria e Marc (R$ 150,00 para cada)

Cenários

- Proprietário pode visualizar as metas das suas lojas
- O proprietário pode visualizar o valor total da meta por vendedor
- Proprietário de loja não tem acesso a metas de outras lojas
- Propor valores para metas com base nas médias de vendas prévias (sugestão)

=end

feature "Metas", :type => :feature do
  
  scenario 'Proprietário pode visualizar as metas das suas lojas' do
    dado_existe_um_proprietario_de_loja
    e_alguns_vendedores_na_loja
    e_uma_meta_de_vendas_para_o_mes_na_loja
    e_diversas_vendas_foram_realizadas_na_loja_durante_o_mes
    quando_proprietario_estiver_logado_na_pagina_de_lojas
    e_clicar_em_metas_da_loja
    entao_foi_para_a_pagina_de_consulta_de_metas
    e_todas_as_metas_estao_sendo_exibidas
  end

  scenario 'O proprietário pode visualizar o valor total da meta por vendedor' do
    dado_existe_um_proprietario_de_loja
    e_alguns_vendedores_na_loja
    e_uma_meta_e_diversas_vendas_realizadas_na_loja_durante_a_meta
    quando_proprietario_estiver_visualizando_as_metas_da_loja
    e_clicar_no_valor_da_meta
    entao_foi_para_a_pagina_visualizacao_da_meta
    e_os_detalhes_da_meta_estao_sendo_exibidos
    e_o_valor_total_das_vendas
    e_o_valor_total_da_meta_por_vendedor
    quando_clicar_em_metas
    entao_foi_para_a_pagina_de_consulta_de_metas
  end

  scenario 'Proprietário de loja não tem acesso às metas de outras lojas' do
    dado_existe_um_proprietario_de_loja
    e_um_segundo_proprietario_com_outras_lojas
    quando_proprietario_estiver_logado_na_pagina_de_lojas
    entao_lojas_do_segundo_proprietario_nao_estarao_disponiveis_para_acesso
    e_nao_existe_botao_para_acessar_lojas_do_segundo_proprietario
  end

  pending 'Propor valores para metas com base nas médias de vendas prévias'

  # ------------------------------------------- Implementação -----------------
  
  def dado_existe_um_proprietario_de_loja
    @proprietario = create(:proprietario)
    @loja = create(:loja, proprietario: @proprietario)
  end

  def e_um_segundo_proprietario_com_outras_lojas
    @proprietario_segundo = create(:proprietario)
    @loja_segundo = create(:loja, proprietario: @proprietario_segundo)
  end

  def e_alguns_vendedores_na_loja
    @vendedores = []
    4.times {@vendedores << create(:vendedor, loja: @loja)}
  end

  def e_uma_meta_de_vendas_para_o_mes_na_loja
    @mes = Time.new.month
    @ano = Time.now.year
    @inicio = Date.new(@ano, @mes, 1)
    @fim = Date.new(@ano, @mes, 28)
    @meta = create(:meta, mes: @mes, ano:@ano, inicio: @inicio, fim: @fim, loja: @loja)
  end


  def e_diversas_vendas_foram_realizadas_na_loja_durante_o_mes
    100.times do
      # Constroi array contendo vendedores aleatórios 
      # e com quantidade variada para participarem da venda
      vendedores = Array.new(@vendedores)
      vendedores.delete(vendedores.sample) if [false,true].sample
      vendedores.delete(vendedores.sample) if [false,true].sample

      create(:dia, meta: @meta, vendedores: vendedores)
    end
  end

  def e_uma_meta_e_diversas_vendas_realizadas_na_loja_durante_a_meta
    e_uma_meta_de_vendas_para_o_mes_na_loja
    e_diversas_vendas_foram_realizadas_na_loja_durante_o_mes
  end


  def quando_proprietario_estiver_logado_na_pagina_de_lojas
    login(@proprietario)
    visit lojas_path
  end

  def e_primeiro_proprietario_estiver_logado_na_pagina_das_lojas
    quando_proprietario_estiver_logado_na_pagina_de_lojas
  end

  def quando_proprietario_estiver_visualizando_as_metas_da_loja
    login(@proprietario)
    visit loja_metas_path(@loja)
  end

  def e_clicar_em_metas_da_loja
    click_on "metas_#{@loja.id}"
  end

  def e_clicar_no_valor_da_meta
    click_on "meta_#{@meta.id}"
  end

  def quando_clicar_em_metas
    click_on "Metas"
  end


  def e_nao_existe_botao_para_acessar_lojas_do_segundo_proprietario
    expect(page).to have_link("metas_#{@loja.id}")
    expect(page).not_to have_link("metas_#{@loja_segundo.id}")
  end

  def entao_foi_para_a_pagina_de_consulta_de_metas
    expect(page).to have_current_path(loja_metas_path(@loja))
  end

  def entao_foi_para_a_pagina_visualizacao_da_meta
    expect(page).to have_current_path(loja_meta_path(@loja.id, @meta.id))
  end

  def entao_lojas_do_segundo_proprietario_nao_estarao_disponiveis_para_acesso
    expect(page).not_to have_content(@loja_segundo.nome)
    expect(page).to have_content(@loja.nome)
  end

  def e_todas_as_metas_estao_sendo_exibidas
    expect(page).to have_content(ActionController::Base.helpers.number_to_currency(@meta.valor, locale: 'pt-BR'))
    expect(page).to have_content(I18n.l(@meta.inicio, locale: 'pt', format: :short))
    expect(page).to have_content(I18n.l(@meta.fim, locale: 'pt', format: :short))
  end

  def e_os_detalhes_da_meta_estao_sendo_exibidos
    expect(page).to have_content("#{@meta.mes}/#{@meta.ano}")
    expect(page).to have_content(ActionController::Base.helpers.number_to_currency(@meta.valor, locale: 'pt-BR'))
    expect(page).to have_content(I18n.l(@meta.inicio, locale: 'pt', format: :short))
    expect(page).to have_content(I18n.l(@meta.fim, locale: 'pt', format: :short))
  end

  def e_o_valor_total_das_vendas
    expect(page).to have_content(ActionController::Base.helpers.number_to_currency(@meta.total, locale: 'pt-BR'))
  end

  def e_o_valor_total_da_meta_por_vendedor
    expect(page).to have_content('Participação dos vendores sobre as vendas')
    total = @meta.total_por_vendedores(@vendedores)
    @vendedores.each do |vendedor|
      expect(page).to have_content(vendedor.nome)
      expect(page).to have_content(ActionController::Base.helpers.number_to_currency(total[vendedor.id], locale: 'pt-BR'))
    end
  end


end
