Por que utilizar o docker com ruby on rails? [Esse artigo][pq-docker] explica quais os benefícios de utilização do docker em um projeto com rails.

[pq-docker]: https://semaphoreci.com/community/tutorials/dockerizing-a-ruby-on-rails-application

Agora precisamos criar um projeto do rails. Mas como fazer isso sem o rails instalado no sistema? O primeiro passo é baixar uma imagem do ruby.  OBS, a imagem do rails está descontinuada (ver https://hub.docker.com/_/rails/)


        docker pull ruby:latest


NOTA: Ler como funciona a imagem do ruby: https://hub.docker.com/_/ruby/

Precisamos invocar o comando `rails new --help`. Primeira tentativa:

        $ docker run -it --rm --user "$(id -u):$(id -g)"   -v "$PWD":/usr/src/app -w /usr/src/app ruby:latest rails new --help
        docker: Error response from daemon: oci runtime error: container_linux.go:265: starting container process caused "exec: \"rails\": executable file not found in $PATH".

A imagem do ruby não vem com Rails instalado. E agora? Precisamos instalar o rails. Ver [documentação sobre instalação do rails][installing-rails].

[installing-rails]: http://guides.rubyonrails.org/getting_started.html#installing-rails

Vamos criar uma imagem temporária com o rails instalado, esta imagem servirá apenas para criar um novo projeto. Vemos na descrição da imagem do ruby que os seguintes comando são executados ON BUILD: "COPY . /usr/src/app and RUN bundle install". Em outras palavras, ele copia o conteúdo do diretório atual para /usr/src/app e executa `bunde install`, que requer um arquivo Gemfile. Para o nosso projeto, queremos que o rails crie o nosso Gemfile. 

Antes disso, vamos verificar qual a versão do ruby que o latest nos trouxe:

        docker run -it ruby:latest
        irb(main):001:0> RUBY_VERSION
        => "2.4.2"

O Comando `run` provavelmente utiliza o `irb` como entrypoint. Para invocar o shell, precisamos especificar um entry point.

NOTA: Várias imagens não possui o bash (/bin/bash) instalado, por isso que estamos invocando o `/bin/sh`.

        docker run -it --entrypoint /bin/sh ruby:latest
        # pwd
        /
        # cd /usr/src/app
        /bin/sh: 2: cd: can't cd to /usr/src/app
        # 

Estranho, era para existir o diretório `/usr/src/app`. Entrei na página da imagem do ruby e inspecionei o código do Dockerfile que gerou a imagem. Não existe `ON BUILD` lá (https://github.com/docker-library/ruby/blob/73d3ed6b06738a7457a24fba9024cad303829c0a/2.4/jessie/Dockerfile). Isto quer dizer que a documentação está errada ou desatualizada. Mas foi bom porque agora sabemos exatamente o que a imagem faz.

LEMBRETE: Cadastrar issue no repositório da imagem para notificar possível problema.

Podemos instalar o rails com o comando `gem install rails` e depois poderíamos criar o projeto com `rails new`, mas o problema que se fizéssemos isso agora, o diterório  seria criado dentro do container e seria apagado depois. Mas vamos testar mesmo assim, isso irá nos custar um pouco de tempo devido as compilações ao instalar as dependências do rails.

NOTA: Se não quiser perder tempo, pule essas instruções.

        $ docker run -it --entrypoint /bin/sh ruby:latest
        # pwd
        /
        # cd /usr/src/app
        /bin/sh: 2: cd: can't cd to /usr/src/app
        # gem install rails
        Fetching: concurrent-ruby-1.0.5.gem (100%)
        Successfully installed concurrent-ruby-1.0.5
        Fetching: i18n-0.9.1.gem (100%)
        ...
        Building native extensions. This could take a while...
        ...
        Fetching: rails-5.1.4.gem (100%)
        Successfully installed rails-5.1.4
        35 gems installed
        # rails new --help
        Usage:
          rails new APP_PATH [options]
        ...
          -T, [--skip-test], [--no-skip-test]                    # Skip test files
        ...


Agora queremos criar um projeto utilizando rspec e heroku. A documentação sobre os projetos com heroku [pode ser vista aqui][heroku]. E sobre instalar com rspec [aqui][rspec1] e [aqui][rspec2]. O desafio é conciliar informações diferentes.

[heroku]: https://devcenter.heroku.com/articles/getting-started-with-rails5
[rspec1]: https://stackoverflow.com/questions/6728618/how-can-i-tell-rails-to-use-rspec-instead-of-test-unit-when-creating-a-new-rails
[rspec2][https://www.devmynd.com/blog/setting-up-rspec-and-capybara-in-rails-5-for-testing/]

NOTA1: A documentação do heroku menciona a instalação do rails sem a documentação (`gem install rails --no-ri --no-rdoc`). Será que poderiamos nos aproveitar disso novamente ou a imagem do ruby já faz isso automático? Eu não sei. Outro ponto é o drive do postgres: `rails new myapp --database=postgresql`. O nosso comendo new precisará utilizar esse parâmetro. E também precisaremos instalar o drive/client do postgres na imagem da nossa aplicação.

NOTA2: Sobre a inclusão do rspec, por enquanto a estratégia é utilizar a opção `-T` e excluir o diretório `test` caso ele seja criado.

NOTA3: Também considero válido verificar os issues relacionados ao repositório da imagem que estamos utilizando. Podemos antever problemas. No momento [vi um issue sobre codificação][issue-codificacao] da aplicação, que talvez seja um problema no futuro.

[issue-codificacao]: https://github.com/docker-library/ruby/issues/70

Então agora o que nos resta é juntar tudo e executar:

        # rails new aplicacao -T --database=postgresql   
              create  
              create  README.md
              create  Rakefile
              create  config.ru
              create  .gitignore
              create  Gemfile
                 run  git init from "."
        Initialized empty Git repository in /aplicacao/.git/
              create  app
              create  app/assets/config/manifest.js
              create  app/assets/javascripts/application.js
              create  app/assets/javascripts/cable.js
              create  app/assets/stylesheets/application.css
              create  app/channels/application_cable/channel.rb
              create  app/channels/application_cable/connection.rb
              create  app/controllers/application_controller.rb
              create  app/helpers/application_helper.rb
              create  app/jobs/application_job.rb
              create  app/mailers/application_mailer.rb
              create  app/models/application_record.rb
              create  app/views/layouts/application.html.erb
              create  app/views/layouts/mailer.html.erb
              create  app/views/layouts/mailer.text.erb
              create  app/assets/images/.keep
              create  app/assets/javascripts/channels
              create  app/assets/javascripts/channels/.keep
              create  app/controllers/concerns/.keep
              create  app/models/concerns/.keep
              create  bin
              create  bin/bundle
              create  bin/rails
              create  bin/rake
              create  bin/setup
              create  bin/update
              create  bin/yarn
              create  config
              create  config/routes.rb
              create  config/application.rb
              create  config/environment.rb
              create  config/secrets.yml
              create  config/cable.yml
              create  config/puma.rb
              create  config/spring.rb
              create  config/environments
              create  config/environments/development.rb
              create  config/environments/production.rb
              create  config/environments/test.rb
              create  config/initializers
              create  config/initializers/application_controller_renderer.rb
              create  config/initializers/assets.rb
              create  config/initializers/backtrace_silencers.rb
              create  config/initializers/cookies_serializer.rb
              create  config/initializers/cors.rb
              create  config/initializers/filter_parameter_logging.rb
              create  config/initializers/inflections.rb
              create  config/initializers/mime_types.rb
              create  config/initializers/new_framework_defaults_5_1.rb
              create  config/initializers/wrap_parameters.rb
              create  config/locales
              create  config/locales/en.yml
              create  config/boot.rb
              create  config/database.yml
              create  db
              create  db/seeds.rb
              create  lib
              create  lib/tasks
              create  lib/tasks/.keep
              create  lib/assets
              create  lib/assets/.keep
              create  log
              create  log/.keep
              create  public
              create  public/404.html
              create  public/422.html
              create  public/500.html
              create  public/apple-touch-icon-precomposed.png
              create  public/apple-touch-icon.png
              create  public/favicon.ico
              create  public/robots.txt
              create  tmp
              create  tmp/.keep
              create  tmp/cache
              create  tmp/cache/assets
              create  vendor
              create  vendor/.keep
              create  package.json
              remove  config/initializers/cors.rb
              remove  config/initializers/new_framework_defaults_5_1.rb
                 run  bundle install
        Don't run Bundler as root. Bundler can ask for sudo if it is needed, and installing your bundle as root will break this application for all
        non-root users on this machine.
        The dependency tzinfo-data (>= 0) will be unused by any of the platforms Bundler is installing for. Bundler is installing for ruby but the dependency is only for x86-mingw32, x86-mswin32, x64-mingw32, java. To add those platforms to the bundle, run `bundle lock --add-platform x86-mingw32 x86-mswin32 x64-mingw32 java`.
        Fetching gem metadata from https://rubygems.org/..........
        Fetching gem metadata from https://rubygems.org/.
        Resolving dependencies.....
        Fetching rake 12.3.0
        Installing rake 12.3.0
        Using concurrent-ruby 1.0.5
        Using i18n 0.9.1
        Fetching minitest 5.10.3
        Installing minitest 5.10.3
        (...)
        Fetching pg 0.21.0
        Installing pg 0.21.0 with native extensions
        Fetching puma 3.10.0
        Installing puma 3.10.0 with native extensions
        (...)
        Bundle complete! 14 Gemfile dependencies, 63 gems now installed.
        Use `bundle info [gemname]` to see where a bundled gem is installed.
                 run  bundle exec spring binstub --all
        * bin/rake: spring inserted
        * bin/rails: spring inserted

OK, o projeto foi criado e as dependências foram baixadas automaticamente. Duas coisas me chamaram atenção:

1. a extensão do posgresql `pg` foi instalada como nativa. Será que vamos precisar instalar algum aplicativo localmente? Na instância dentro do heroku eu lembro que não, mas será que localmente vamos precisar?

2. O diretório `test` não foi criado. Ótimo, porque não haverá nada para ser apagado.

NOTA:  Provavelmente vamos precisar de utilizar o docker-composer para ter um container apenas com o banco de dados. Isso me intimida um pouco pois apesar de utilizar testes, é a primeira vez que estou tentando utilizar o docker em um projeto rails desde o início. Existe um risco envolvido, principalmente porque estou fazendo para me submeter a um processo seletivo de emprego.

O diretório foi criado, vamos testar executá-lo?

        # bin/rails server
        /usr/local/lib/ruby/site_ruby/2.4.0/bundler/runtime.rb:84:in `rescue in block (2 levels) in require': There was an error while trying to load the gem 'uglifier'. (Bundler::GemRequireError)
        Gem Load Error is: Could not find a JavaScript runtime. See https://github.com/rails/execjs for a list of available runtimes.
        Backtrace for gem load error is:
        /usr/local/bundle/gems/execjs-2.7.0/lib/execjs/runtimes.rb:58:in `autodetect'
        /usr/local/bundle/gems/execjs-2.7.0/lib/execjs.rb:5:in `<module:ExecJS>'
        /usr/local/bundle/gems/execjs-2.7.0/lib/execjs.rb:4:in `<top (required)>'
        /usr/local/bundle/gems/uglifier-3.2.0/lib/uglifier.rb:5:in `require'
        /usr/local/bundle/gems/uglifier-3.2.0/lib/uglifier.rb:5:in `<top (required)>'
        /usr/local/lib/ruby/site_ruby/2.4.0/bundler/runtime.rb:81:in `require'
        /usr/local/lib/ruby/site_ruby/2.4.0/bundler/runtime.rb:81:in `block (2 levels) in require'
        /usr/local/lib/ruby/site_ruby/2.4.0/bundler/runtime.rb:76:in `each'
        /usr/local/lib/ruby/site_ruby/2.4.0/bundler/runtime.rb:76:in `block in require'
        /usr/local/lib/ruby/site_ruby/2.4.0/bundler/runtime.rb:65:in `each'
        /usr/local/lib/ruby/site_ruby/2.4.0/bundler/runtime.rb:65:in `require'
        /usr/local/lib/ruby/site_ruby/2.4.0/bundler.rb:114:in `require'
        /aplicacao/config/application.rb:17:in `<top (required)>'
        /usr/local/bundle/gems/railties-5.1.4/lib/rails/commands/server/server_command.rb:133:in `require'
        /usr/local/bundle/gems/railties-5.1.4/lib/rails/commands/server/server_command.rb:133:in `block in perform'
        /usr/local/bundle/gems/railties-5.1.4/lib/rails/commands/server/server_command.rb:130:in `tap'
        /usr/local/bundle/gems/railties-5.1.4/lib/rails/commands/server/server_command.rb:130:in `perform'
        /usr/local/bundle/gems/thor-0.20.0/lib/thor/command.rb:27:in `run'
        /usr/local/bundle/gems/thor-0.20.0/lib/thor/invocation.rb:126:in `invoke_command'
        /usr/local/bundle/gems/thor-0.20.0/lib/thor.rb:387:in `dispatch'
        /usr/local/bundle/gems/railties-5.1.4/lib/rails/command/base.rb:63:in `perform'
        /usr/local/bundle/gems/railties-5.1.4/lib/rails/command.rb:44:in `invoke'
        /usr/local/bundle/gems/railties-5.1.4/lib/rails/commands.rb:16:in `<top (required)>'
        /aplicacao/bin/rails:9:in `require'
        /aplicacao/bin/rails:9:in `<top (required)>'
        /usr/local/bundle/gems/spring-2.0.2/lib/spring/client/rails.rb:28:in `load'
        /usr/local/bundle/gems/spring-2.0.2/lib/spring/client/rails.rb:28:in `call'
        /usr/local/bundle/gems/spring-2.0.2/lib/spring/client/command.rb:7:in `call'
        /usr/local/bundle/gems/spring-2.0.2/lib/spring/client.rb:30:in `run'
        /usr/local/bundle/gems/spring-2.0.2/bin/spring:49:in `<top (required)>'
        /usr/local/bundle/gems/spring-2.0.2/lib/spring/binstub.rb:31:in `load'
        /usr/local/bundle/gems/spring-2.0.2/lib/spring/binstub.rb:31:in `<top (required)>'
        /usr/local/lib/ruby/site_ruby/2.4.0/rubygems/core_ext/kernel_require.rb:70:in `require'
        /usr/local/lib/ruby/site_ruby/2.4.0/rubygems/core_ext/kernel_require.rb:70:in `require'
        /aplicacao/bin/spring:15:in `<top (required)>'
        bin/rails:3:in `load'
        bin/rails:3:in `<main>'
        Bundler Error Backtrace:
            from /usr/local/lib/ruby/site_ruby/2.4.0/bundler/runtime.rb:80:in `block (2 levels) in require'
            from /usr/local/lib/ruby/site_ruby/2.4.0/bundler/runtime.rb:76:in `each'
            from /usr/local/lib/ruby/site_ruby/2.4.0/bundler/runtime.rb:76:in `block in require'
            from /usr/local/lib/ruby/site_ruby/2.4.0/bundler/runtime.rb:65:in `each'
            from /usr/local/lib/ruby/site_ruby/2.4.0/bundler/runtime.rb:65:in `require'
            from /usr/local/lib/ruby/site_ruby/2.4.0/bundler.rb:114:in `require'
            from /aplicacao/config/application.rb:17:in `<top (required)>'
            from /usr/local/bundle/gems/railties-5.1.4/lib/rails/commands/server/server_command.rb:133:in `require'
            from /usr/local/bundle/gems/railties-5.1.4/lib/rails/commands/server/server_command.rb:133:in `block in perform'
            from /usr/local/bundle/gems/railties-5.1.4/lib/rails/commands/server/server_command.rb:130:in `tap'
            from /usr/local/bundle/gems/railties-5.1.4/lib/rails/commands/server/server_command.rb:130:in `perform'
            from /usr/local/bundle/gems/thor-0.20.0/lib/thor/command.rb:27:in `run'
            from /usr/local/bundle/gems/thor-0.20.0/lib/thor/invocation.rb:126:in `invoke_command'
            from /usr/local/bundle/gems/thor-0.20.0/lib/thor.rb:387:in `dispatch'
            from /usr/local/bundle/gems/railties-5.1.4/lib/rails/command/base.rb:63:in `perform'
            from /usr/local/bundle/gems/railties-5.1.4/lib/rails/command.rb:44:in `invoke'
            from /usr/local/bundle/gems/railties-5.1.4/lib/rails/commands.rb:16:in `<top (required)>'
            from /aplicacao/bin/rails:9:in `require'
            from /aplicacao/bin/rails:9:in `<top (required)>'
            from /usr/local/bundle/gems/spring-2.0.2/lib/spring/client/rails.rb:28:in `load'
            from /usr/local/bundle/gems/spring-2.0.2/lib/spring/client/rails.rb:28:in `call'
            from /usr/local/bundle/gems/spring-2.0.2/lib/spring/client/command.rb:7:in `call'
            from /usr/local/bundle/gems/spring-2.0.2/lib/spring/client.rb:30:in `run'
            from /usr/local/bundle/gems/spring-2.0.2/bin/spring:49:in `<top (required)>'
            from /usr/local/bundle/gems/spring-2.0.2/lib/spring/binstub.rb:31:in `load'
            from /usr/local/bundle/gems/spring-2.0.2/lib/spring/binstub.rb:31:in `<top (required)>'
            from /usr/local/lib/ruby/site_ruby/2.4.0/rubygems/core_ext/kernel_require.rb:70:in `require'
            from /usr/local/lib/ruby/site_ruby/2.4.0/rubygems/core_ext/kernel_require.rb:70:in `require'
            from /aplicacao/bin/spring:15:in `<top (required)>'
            from bin/rails:3:in `load'
            from bin/rails:3:in `<main>'

Estranho, eu esperava ver o servidor funcionando. Será que faltou instalar alguma coisa?

A mensagem de erro está coerente com a documentação de instalação do rails, precisamos descomentar `therubyracer` no Gemfile. O problema é que essa imagem do ruby não possui editor de texto.  Podeíramos instalar o pico ou vim, ou ainda utilizar o `sed` que vem disponível:

        # apt-get install vim
        Reading package lists... Done
        Building dependency tree       
        Reading state information... Done
        E: Unable to locate package vim
        # 

Achoq ue estamos precisando atualizar as fontes:

        # apt-get update
        (...)
        # apt-get install pico
        Reading package lists... Done
        Building dependency tree       
        Reading state information... Done
        Package pico is not available, but is referred to by another package.
        This may mean that the package is missing, has been obsoleted, or
        is only available from another source
        However the following packages replace it:
          nano
        E: Package 'pico' has no installation candidate
        # apt-get install nano
        # nano Gemfile

Encontre a linha contendo `therubyracer` e remova o comentário. Vamos tentar novamente:

        # bin/rails server
        Could not find gem 'therubyracer' in any of the gem sources listed in your Gemfile.
        Run `bundle install` to install missing gems.

OOPs. Faltou instalar o gem:

        # bundle install
        (...)
        Fetching therubyracer 0.12.3
        Installing therubyracer 0.12.3 with native extensions

Agora vamos tentar novamente:

        # bin/rails server
        => Booting Puma
        => Rails 5.1.4 application starting in development 
        => Run `rails server -h` for more startup options
        Puma starting in single mode...
        * Version 3.10.0 (ruby 2.4.2-p198), codename: Russell's Teapot
        * Min threads: 5, max threads: 5
        * Environment: development
        * Listening on tcp://0.0.0.0:3000
        Use Ctrl-C to stop

Perfeito! Erra isso que esperávamos. Infelizmente não podemos acessar `htp://0.0.0.0:3000` porque isso está sendo executando dentro do container. Vamos vamos tentar acessar de dentro. Pressinamos CTRL+C.

        ^C- Gracefully stopping, waiting for requests to finish
        === puma shutdown: 2017-11-18 04:25:10 +0000 ===
        - Goodbye!
        Exiting
        # 

Vamos executar o server em segundo plano com `&`  no final do comando, e testar com o curl:

        # bin/rails server &
        # => Booting Puma
        => Rails 5.1.4 application starting in development 
        => Run `rails server -h` for more startup options
        Puma starting in single mode...
        * Version 3.10.0 (ruby 2.4.2-p198), codename: Russell's Teapot
        * Min threads: 5, max threads: 5
        * Environment: development
        * Listening on tcp://0.0.0.0:3000
        Use Ctrl-C to stop

        # curl http://0.0.0.0:3000
        Started GET "/" for 127.0.0.1 at 2017-11-18 04:26:32 +0000
        Processing by Rails::WelcomeController#index as */*
          Rendering /usr/local/bundle/gems/railties-5.1.4/lib/rails/templates/rails/welcome/index.html.erb
          Rendered /usr/local/bundle/gems/railties-5.1.4/lib/rails/templates/rails/welcome/index.html.erb (7.8ms)
        Completed 200 OK in 931ms (Views: 56.0ms)


        <!DOCTYPE html>
        <html>
        <head>
          <title>Ruby on Rails</title>
          <meta charset="utf-8">
          <meta name="viewport" content="width=device-width">
          <style type="text/css" media="screen" charset="utf-8">
        (...)
          </style>
        </head>

        <body>
          <div class="container">
            <section>
              <p>
                <a href="http://rubyonrails.org">
        (...)
                </a>
              </p>

              <h1>Yay! You&rsquo;re on Rails!</h1>

        (...)

              <p class="version">
                <strong>Rails version:</strong> 5.1.4<br />
                <strong>Ruby version:</strong> 2.4.2 (x86_64-linux)
              </p>
            </section>
          </div>
        </body>
        </html>
        # 

Para mim parece ótimo! Por hoje vamos encerrar, já são 01:50 da manhã e minha esposa dormindo sozinha.

Mas antes de encerrar, vamos sair da máquina e voltar novamente:

        # exit
        dudu@eduardo-u16:~/w$ docker run -it --entrypoint /bin/sh ruby:latest
        # ls
        bin  boot  dev    etc  home  lib    lib64  media  mnt  opt    proc  root  run  sbin  srv  sys  tmp  usr  var
        # 

Como era esperado, tudo o que fizemos sumiu e agora estamos com a imagem no seu estado inicial novamente. Na próxima etapa vamos precisar montar um volume para criar o projeto em nosso sistema de arquivo local.

