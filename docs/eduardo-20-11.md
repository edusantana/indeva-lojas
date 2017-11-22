# 20/11/2017

No dia anterior, desisti de utilizar o docker no desenvolvimento, por enquanto, vamos adotar o workflow normal de rails.


# Instalação

- Instalação do [rvm](https://rvm.io/rvm/install), [ruby](https://rvm.io/rvm/install) e rails
- [postgresql](https://stackoverflow.com/questions/3116015/how-to-install-postgresqls-pg-gem-on-ubuntu)
- [factory_bot_rails](https://github.com/thoughtbot/factory_bot_rails) e [factory_bot](https://github.com/thoughtbot/factory_bot/wiki)
- [capybara](https://github.com/teamcapybara/capybara)

- configurando [o idioma português](https://pt.stackoverflow.com/questions/19512/como-programar-em-portugu%C3%AAs-no-ruby-on-rails). [Problema com plural no rails 5 necessita de spring stop](https://github.com/rails/spring/issues/486).

## Requisitos

Vamos rever [os requisitos](https://gist.github.com/hudsonsferreira/c695a98c29212f77fc4cda9703543d70):

- O proprietário precisa se autenticar no sistema
- O proprietário pode visualizar apenas as metas das suas lojas
- Visualizar o valor total da meta por vendedor

A aplicação está descrita [nesse gist](https://gist.github.com/hudsonsferreira/c695a98c29212f77fc4cda9703543d70).


Vamos instalar o `mini_racer` e `capybara` para os testes.

[capybara]: https://github.com/teamcapybara/capybara

## Continuous deployment

O objetivo será entregar o máximo de valor, o mais rápido possível, com vários deploys e sem derpediçar tempo implementando outras coisas.

## Criando as features

Em interações com o cliente, o uso do Cucumber era recomendado pois possibilitava uma linguagem de features escritas em português. Atualmente, podemos escrever os testes com rspec e capybara com legibilidade, mas sem o esforço necessário para interpretar o texto no idoma, eu prefiro [essa nova abordagem](tests-with-rspec).

[tests-with-rspec]: https://about.futurelearn.com/blog/how-we-write-readable-feature-tests-with-rspec

Vamos nos organizar antes de entrar em contato com o cliente.


        rails generate rspec:feature autenticacao
        rails generate rspec:feature meta

- [Sintaxe para escrite de cenários](https://relishapp.com/rspec/rspec-rails/docs/feature-specs/feature-spec)
