# 20/11/2017

No dia anterior, com instalação e problema que tive para configurar o rails em portugues. Hoje vamos iniciara os testes de desenvolvimento das funcionalidades.

# Instalações

## Funcionalidades


- Lojas
- Vendas
- Metas

### Lojas

Eu escrevi os testes da funcionalidade 'lojas', mas quando fui fazer eles falhar tive problemas com as dependências e o ambiente de produção. Eu cadastrei [um issue](https://github.com/edusantana/indeva-lojas/issues/4):

        dudu@eduardo-u16:~/w/indeva/indeva-lojas$ bundle exec rake -T
        Your Ruby version is 2.3.1, but your Gemfile specified 2.4.1
        dudu@eduardo-u16:~/w/indeva/indeva-lojas$ ruby --version
        ruby 2.4.1p111 (2017-03-22 revision 58053) [x86_64-linux]
        dudu@eduardo-u16:~/w/indeva/indeva-lojas$ rake -T
        Your Ruby version is 2.3.1, but your Gemfile specified 2.4.1

Problemas de dependências e com as versões de ruby.

