require 'rails_helper'

=begin

Metas

- Meta possui data de início e fim, mês de referência e valor
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

- Proprietário de loja acessa meta mensal
- Proprietário de loja não tem acesso a metas de outras lojas
- Propor valores para metas com base nas médias de vendas prévias (sugestão)

=end

feature "Metas", :type => :feature do
  
  scenario 'Proprietário de loja acessa meta mensal' do
    dado_existe_um_proprietario_com_loja_cadastrado
    e_existe_uma_meta_para_os_vendedores_da_loja
    e_diversas_vendas_foram_realizadas_durante_os_dias_da_meta_na_loja
    e_proprietario_esta_logado_na_pagina_de_lojas
    quando_clicar_em_metas_da_loja
    entao_foi_para_a_pagina_de_consulta_de_metas
    e_as_metas_estao_selecionaveis_a_partir_do_mes_de_referencia_data_inicio_e_fim
    quando_selecionar_uma_meta
    e_clicar_em_consultar_meta
    entao_todas_as_vendas_e_vendedores_dos_dias_que_correspondem_ameta_estao_sendo_exibidos
    e_permanece_na_pagina_de_consulta_de_metas
  end

  scenario 'Proprietário de loja não tem acesso às metas de outras lojas' do
    dado_existe_um_proprietario_com_loja_cadastrado
    e_um_segundo_proprietario_com_outras_lojas
    e_primeiro_proprietario_estiver_logado_na_pagina_das_lojas
    entao_lojas_do_segundo_proprietario_nao_estarao_disponiveis_para_acesso
    e_nao_existe_botao_para_acessar_lojas_do_segundo_proprietario
  end

  scenario 'Voltando para acessar página das lojas' do
    dado_existe_um_proprietario_com_loja_cadastrado
    e_proprietario_esta_logado_na_pagina_de_lojas
    quando_clicar_no_botao_lojas
    entao_fui_para_pagina_das_lojas
  end

end
