# 20/11/2017

O dia anterior não foi produtivo, eu tive problemas com as dependências do sistema, e ainda não resolvi. Eu apaguei o ruby do sistema e agora vou tentar outras estratégias. Acredito que uma solução com o docker seria de extrema ajuda, pois evitaria esse tipo de problema que eu tive.


## Problemas com a versão do ruby e dependências

- [LoadError: incompatible library version gems/nokogiri-1.8.1 #4](https://github.com/edusantana/indeva-lojas/issues/4)

- removi o ruby do sistema (ubuntu)
- removi ruby do rvm
- remvi gems


        rvm uninstall ruby-2.4.1
        $ ruby --version
        bash: /usr/share/rvm/rubies/ruby-2.4.1/bin/ruby: Arquivo ou diretório não encontrado
        dudu@eduardo-u16:~/w/indeva/indeva-lojas$ which ruby

Estranho. `ruby --version` deveria dá outro erro, como ele sabe que deveria executar o 2.4.1 e não existe nenhum ruby instalado? Deve ser algo do rvm.

        rvm repair all
        $ exit
        $ ruby --version
        O programa 'ruby' não está instalado no momento. Você pode instalá-lo digitando:
        sudo apt install ruby
        dudu@eduardo-u16:~/w/indeva/indeva-lojas$ ruby --bash^C
        dudu@eduardo-u16:~/w/indeva/indeva-lojas$ bash --login
        Required ruby-2.4.1 is not installed.
        To install do: 'rvm install "ruby-2.4.1"'
        dudu@eduardo-u16:~/w/indeva/indeva-lojas$ 
        rvm gemset empty mygems
        $ rm -rf /home/dudu/.rvm/gems
        $ rvm install "ruby-2.4.1"
        Searching for binary rubies, this might take some time.
        Found remote file https://rvm_io.global.ssl.fastly.net/binaries/ubuntu/16.04/x86_64/ruby-2.4.1.tar.bz2
        Checking requirements for ubuntu.
        Requirements installation successful.
        ruby-2.4.1 - #configure
        ruby-2.4.1 - #download
        ruby-2.4.1 - #validate archive
        ruby-2.4.1 - #extract
        ruby-2.4.1 - #validate binary
        ruby-2.4.1 - #setup
        ruby-2.4.1 - #gemset created /home/dudu/.rvm/gems/ruby-2.4.1@global
        ruby-2.4.1 - #importing gemset /usr/share/rvm/gemsets/global.gems...................................
        ruby-2.4.1 - #generating global wrappers........
        ruby-2.4.1 - #gemset created /home/dudu/.rvm/gems/ruby-2.4.1
        ruby-2.4.1 - #importing gemsetfile /usr/share/rvm/gemsets/default.gems evaluated to empty gem list
        ruby-2.4.1 - #generating default wrappers........
        $ gem install bundler
        $ bundle install

Agora estamos com outro erro:

        $ rake -T
        rake aborted!
        NoMethodError: undefined method `last_comment' for #<Rake::Application:0x000000018ecb68>
        /home/dudu/.rvm/gems/ruby-2.4.1/gems/rspec-core-3.0.4/lib/rspec/core/rake_task.rb:101:in `define'
        /home/dudu/.rvm/gems/ruby-2.4.1/gems/rspec-core-3.0.4/lib/rspec/core/rake_task.rb:78:in `initialize'
        /home/dudu/.rvm/gems/ruby-2.4.1/gems/rspec-rails-3.0.2/lib/rspec/rails/tasks/rspec.rake:11:in `new'
        /home/dudu/.rvm/gems/ruby-2.4.1/gems/rspec-rails-3.0.2/lib/rspec/rails/tasks/rspec.rake:11:in `<top (required)>'
        /home/dudu/.rvm/gems/ruby-2.4.1/gems/rspec-rails-3.0.2/lib/rspec-rails.rb:13:in `load'
        /home/dudu/.rvm/gems/ruby-2.4.1/gems/rspec-rails-3.0.2/lib/rspec-rails.rb:13:in `block in <class:Railtie>'
        /home/dudu/.rvm/gems/ruby-2.4.1/gems/railties-5.1.4/lib/rails/railtie.rb:241:in `instance_exec'
        /home/dudu/.rvm/gems/ruby-2.4.1/gems/railties-5.1.4/lib/rails/railtie.rb:241:in `block in run_tasks_blocks'
        /home/dudu/.rvm/gems/ruby-2.4.1/gems/railties-5.1.4/lib/rails/railtie.rb:250:in `each'
        /home/dudu/.rvm/gems/ruby-2.4.1/gems/railties-5.1.4/lib/rails/railtie.rb:250:in `each_registered_block'
        /home/dudu/.rvm/gems/ruby-2.4.1/gems/railties-5.1.4/lib/rails/railtie.rb:241:in `run_tasks_blocks'
        /home/dudu/.rvm/gems/ruby-2.4.1/gems/railties-5.1.4/lib/rails/application.rb:439:in `block in run_tasks_blocks'
        /home/dudu/.rvm/gems/ruby-2.4.1/gems/railties-5.1.4/lib/rails/engine/railties.rb:13:in `each'
        /home/dudu/.rvm/gems/ruby-2.4.1/gems/railties-5.1.4/lib/rails/engine/railties.rb:13:in `each'
        /home/dudu/.rvm/gems/ruby-2.4.1/gems/railties-5.1.4/lib/rails/application.rb:439:in `run_tasks_blocks'
        /home/dudu/.rvm/gems/ruby-2.4.1/gems/railties-5.1.4/lib/rails/engine.rb:457:in `load_tasks'
        /home/alexandre/w/indeva/indeva-lojas/Rakefile:6:in `<top (required)>'
        /home/dudu/.rvm/gems/ruby-2.4.1/gems/rake-12.3.0/exe/rake:27:in `<top (required)>'
        /home/dudu/.rvm/gems/ruby-2.4.1/bin/ruby_executable_hooks:15:in `eval'
        /home/dudu/.rvm/gems/ruby-2.4.1/bin/ruby_executable_hooks:15:in `<main>'
        (See full trace by running task with --trace)

Corrigi as dependências.

# fazendo os testes falharem

        $ RAILS_ENV=test bundle exec rspec spec/features/lojas_spec.rb 

        An error occurred while loading ./spec/features/lojas_spec.rb.
        Failure/Error: ActiveRecord::Migration.maintain_test_schema!

        ActiveRecord::NoDatabaseError:
          FATAL:  role "dudu" does not exist
        (...)
        # --- Caused by: ---
        # PG::ConnectionBad:
        #   FATAL:  role "dudu" does not exist
        #   /home/dudu/.rvm/gems/ruby-2.4.1/gems/pg-0.21.0/lib/pg.rb:56:in `initialize'
        $ RAILS_ENV=test bundle exec rspec spec/features/lojas_spec.rb
        $ rake db:setup
        FATAL:  role "dudu" does not exist
        Couldn't create database for {"adapter"=>"postgresql", "encoding"=>"unicode", "pool"=>5, "database"=>"indeva-lojas_development"}
        rake aborted!
        ActiveRecord::NoDatabaseError: FATAL:  role "dudu" does not exist

Foi necessário instalar o postgres e dar permissão de criação de base para o usuário.

Agora, finalmente o teste está falhando.

- Instalando devise
- comportamento estranho de factory_bot tomou bastante tempo também.
- Instalação do `devise` demorando muito porque o rails está em `pt-BR`

add_reference :lojas, :proprietario, foreign_key: {to_table: :users}


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
