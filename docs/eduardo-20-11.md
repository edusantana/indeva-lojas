# 20/11/2017

Na parte anterior, vimos o rails executando, porém perdemos todos os arquivos da criação do projeto.

Precisamos criar um mecanismo para criar arquivos no sistema local, de dentro do container. Vamos tentar utilizando a opção `mount` com o tipo `bind` do docker:

[mount-bind]: https://docs.docker.com/engine/admin/volumes/bind-mounts/#start-a-container-with-a-bind-mount


        $ mkdir indeva
        $ cd indeva
        $ docker run -it --entrypoint /bin/sh --mount type=bind,source="$(pwd)",target=/app ruby:latest
        #

Ótimo, funcionou sem problemas. Eu criei um diretório indeva, aonde o projeto será criado. Entrei nele, e em seguida executei a imagem montando o diretório recém criado em `/app`. Vamos verificar o sistema de arquivo dentro do container:

        # ls
        app  bin  boot	dev  etc  home	lib  lib64  media  mnt	opt  proc  root  run  sbin  srv  sys  tmp  usr	var
        # cd app
        # ls

Percebemos que `app` foi criado e sem nenhum arquivo. Agora, vamos criar um arquivo, sair e verificar se o arquivo criado existe no sistema de arquivo local.

        # touch teste-de-criacao.txt
        # exit
        $ ls
        teste-de-criacao.txt

OK, o arquivo foi criado! No entanto, ele foi criado pelo usuário root:

        $ ls -la
        drwxrwxr-x  2 dudu dudu  4096 Nov 18 10:11 .
        drwxr-xr-x 25 dudu dudu  4096 Nov 18 09:59 ..
        -rw-r--r--  1 root root     0 Nov 18 10:11 teste-de-criacao.txt
        $ rm teste-de-criacao.txt 
        rm: remover arquivo comum vazio 'teste-de-criacao.txt' protegido contra escrita? s
        
Pesquisando sobre permissões de arquivo, encontrei [esse artigo][docker-uid] explicando para utilizar as opções `-e USER=$USER  -e USERID=$UID`. Vamos ao teste:

[docker-udi]: https://github.com/rocker-org/rocker/wiki/Sharing-files-with-host-machine


        $ docker run -it --entrypoint /bin/sh --mount type=bind,source="$(pwd)",target=/app -e USER=$USER  -e USERID=$UID ruby:latest
        # cd app
        # ls
        # touch novo-arquivo.txt
        # exit
        $ ls -la
        drwxrwxr-x  2 dudu dudu  4096 Nov 18 10:30 .
        drwxr-xr-x 25 dudu dudu  4096 Nov 18 09:59 ..
        -rw-r--r--  1 root root     0 Nov 18 10:30 novo-arquivo.txt
        $ rm novo-arquivo.txt 
        rm: remover arquivo comum vazio 'novo-arquivo.txt' protegido contra escrita? y


Não funcinou. Embora o arquivo foi criado, ele continuou sendo criado com permissão de root. Por enquanto, no momento de criação do projeto, vamos utilizar essa alternativa para não perder mais tempo.

OOPS! Eu lembrei que ontem havia um comando com permissão, vamos testar com aquelas opções:

        $ docker run -it --rm --user "$(id -u):$(id -g)" --entrypoint /bin/sh --mount type=bind,source="$(pwd)",target=/app  ruby:latest
        $ cd app
        $ ls
        $ touch NOVO-ARQUIVO.txt
        $ exit
        $ ls -la
        drwxrwxr-x  2 dudu dudu  4096 Nov 18 10:39 .
        drwxr-xr-x 25 dudu dudu  4096 Nov 18 09:59 ..
        -rw-r--r--  1 dudu dudu     0 Nov 18 10:39 NOVO-ARQUIVO.txt

OBA! Funcinou! As permissões do arquivo agora estão com o usuário `dudu`. No entanto, eu percebi que o shell do container não está mais com o símbolo `#`, e está com o símbolo `$` habitual. Possivelmente está executando com outro usuário. 

LEMBRETE: Compreender a diferença do shell com `#` e `$`.

## Criando o projeto

        docker run -it --rm --user "$(id -u):$(id -g)" --entrypoint /bin/sh --mount type=bind,source="$(pwd)",target=/app  ruby:latest

Vamos utilizar como nome do projeto `indeva-lojas`, e sejamos paciente porque precisará baixar e instalar o rails e todas duas dependências novamente:


        $ cd app
        $ gem install rails
        (...)
        Fetching: rails-5.1.4.gem (100%)
        Successfully installed rails-5.1.4
        35 gems installed
        $ rails new indeva-lojas -T --database=postgresql
        (...)
        Bundle complete! 14 Gemfile dependencies, 63 gems now installed.
        Use `bundle info [gemname]` to see where a bundled gem is installed.
                 run  bundle exec spring binstub --all
        `/` is not writable.
        Bundler will use `/tmp/bundler/home/unknown' as your home directory temporarily.
        * bin/rake: spring inserted
        * bin/rails: spring inserted

Agora vamos descomentar a linha de therubyracer utilizando [um comando sed][sed]. Primeiro descobrimos a linha com os comandos `cat` e `grep`:

[sed]: https://stackoverflow.com/questions/11145270/bash-replace-an-entire-line-in-a-text-file

        $ cd indeva-lojas
        $ cat -n Gemfile | grep therubyracer
            20	# gem 'therubyracer', platforms: :ruby

Agora executamos um comando e verificamos o resultado:

        $ sed -i "20s/\# /gem 'therubyracer', platforms: :ruby/" Gemfile
        $ cat -n Gemfile | grep therubyracer
            20	gem 'therubyracer', platforms: :rubygem 'therubyracer', platforms: :ruby

Na realidade, agora percebi que não é mais necessário realizar a alteração, poderíamos ter feito com um editor de texto normal, uma vez que o arquivo se encontra em nosso sistema de arquivo local.

NOTA: O seguinte [issue](https://github.com/rails/rails/issues/29276) indica 
que `therubyracer` está sendo removido de rails em favor de [mini_racer](https://github.com/discourse/mini_racer).

Agora vamos criar o projeto no Github. Lembra de **NÃO** marcar `Initialize this repository with a README`.

        $ git add -A :/
        $ git commit -m "Estrutura inicial"
        [master (root-commit) e7070b5] Estrutura inicial
         66 files changed, 1229 insertions(+)
         create mode 100644 .gitignore
         create mode 100644 Gemfile
         create mode 100644 Gemfile.lock
         create mode 100644 README.md
         create mode 100644 Rakefile
        (...)
        $ git remote add origin git@github.com:edusantana/indeva-lojas.git
        $ git push -u origin master
        Counting objects: 80, done.
        Delta compression using up to 4 threads.
        Compressing objects: 100% (66/66), done.
        Writing objects: 100% (80/80), 20.98 KiB | 0 bytes/s, done.
        Total 80 (delta 2), reused 0 (delta 0)
        remote: Resolving deltas: 100% (2/2), done.
        To git@github.com:edusantana/indeva-lojas.git
         * [new branch]      master -> master
        Branch master set up to track remote branch master from origin.


Agora vamos incluir o `rspec`. Embora costumo tomar por base artigos como referências, como [este explicando a instalação do rspec][rspec-artigo], eu também prefiro consultar as documentações oficiais dos repositórios. A documentação do [rspec-rails][rspec-rails] indica que precisamos adicionar o seguinte texto no Gemfile:

        group :test, :development do
          gem 'rspec-rails', '~> 3.0.0'
        end

[rspec-artigo]: https://www.devmynd.com/blog/setting-up-rspec-and-capybara-in-rails-5-for-testing/
[rspec-rails]: https://relishapp.com/rspec/rspec-rails/docs

E invocar:

        script/rails generate rspec:install

Se a gente executar essa instrução vamos preceber que precisaremos instalar a dependência do rspec novamente.

## Criando imagem de desenvolvimento

Agora chegamos ao ponto que precisamos criar e utilizar uma imagem específica para nossa aplicação, aonde teremos todas as dependências instaladas.

Como fazer isso? Não sei qual a boa prática. Segue algumas referências pesquisadas:

- https://docs.docker.com/engine/reference/builder/
- https://robots.thoughtbot.com/rails-on-docker
- https://blog.codeship.com/testing-rails-application-docker/
- https://github.com/zuazo/dockerspec
- https://blog.carbonfive.com/2015/03/17/docker-rails-docker-compose-together-in-your-development-workflow/
- https://dzone.com/articles/testing-your-rails-application-with-docker


A documentação da imagem ruby indica que irá invocar bundle install em /usr/app/src. Então criei o Dockerfile com o seguinte conteúdo:


        FROM ruby:2.4.2
        RUN mkdir /usr/src/app
        COPY . /usr/src/app
        WORKDIR /usr/src/app

Gerando imagem:

        $ docker build . -t indeva
        Sending build context to Docker daemon  284.2kB
        Step 1/4 : FROM ruby:2.4.2
         ---> 88d18a616777
        Step 2/4 : RUN mkdir /usr/src/app
         ---> Running in a04046e2e080
         ---> a5edaedbcb1e
        Removing intermediate container a04046e2e080
        Step 3/4 : COPY . /usr/src/app
         ---> 8e0ef351af8b
        Step 4/4 : WORKDIR /usr/src/app
         ---> 191d413eed39
        Removing intermediate container 6d7613e780d1
        Successfully built 191d413eed39
        Successfully tagged indeva:latest

Não funcionou como esperado. A [documentação da imagem ruby][docker-ruby] realmente está errada. Não existe o passo `bundle install` no ON BUILD. Então vamos precisar fazer isso manualmente, eis o Dockerfile:

[docker-ruby]: https://hub.docker.com/_/ruby/

        FROM ruby:2.4.2

        ENV APP_HOME /app
        RUN mkdir $APP_HOME
        WORKDIR $APP_HOME

        ADD Gemfile* $APP_HOME/
        RUN bundle install

        ADD . $APP_HOME


E a execução:

        $ docker build . -t indeva
        Sending build context to Docker daemon  284.2kB
        Step 1/7 : FROM ruby:2.4.2
         ---> 88d18a616777
        Step 2/7 : ENV APP_HOME /app
         ---> Using cache
         ---> 93e09df48eb8
        Step 3/7 : RUN mkdir $APP_HOME
         ---> Using cache
         ---> 0481e65b1bdb
        Step 4/7 : WORKDIR $APP_HOME
         ---> Using cache
         ---> 80b3094ae4a4
        Step 5/7 : ADD Gemfile* $APP_HOME/
         ---> a1ca97fb7d1c
        Step 6/7 : RUN bundle install
         ---> Running in facc9884844a
        The dependency tzinfo-data (>= 0) will be unused by any of the platforms Bundler is installing for. Bundler is installing for ruby but the dependency is only for x86-mingw32, x86-mswin32, x64-mingw32, java. To add those platforms to the bundle, run `bundle lock --add-platform x86-mingw32 x86-mswin32 x64-mingw32 java`.
        Fetching gem metadata from https://rubygems.org/...........
        Fetching gem metadata from https://rubygems.org/..
        Resolving dependencies....
        Fetching rake 12.3.0
        Installing rake 12.3.0
        (...)
        Bundle complete! 16 Gemfile dependencies, 72 gems now installed.
        Bundled gems are installed into `/usr/local/bundle`
         ---> e0ae0ae8e1c5
        Removing intermediate container facc9884844a
        Step 7/7 : ADD . $APP_HOME
         ---> 430130194a14
        Successfully built 430130194a14
        Successfully tagged indeva:latest

Vamos concluir a instalação do rspec:

        $ docker run -it --entrypoint /bin/sh --mount type=bind,source="$(pwd)",target=/app indeva
        # bin/rails g rspec:install
        Running via Spring preloader in process 29
              create  .rspec
              create  spec
              create  spec/spec_helper.rb
              create  spec/rails_helper.rb

Ótimo, agora vamos executar os testes, ainda dentro do container:

        # bundle exec rspec
        No examples found.
        
        Finished in 0.00054 seconds (files took 0.13514 seconds to load)
        0 examples, 0 failures

O rspec está funcionando. Agora vamos commitar tudo. Antes disso, vamos [criar um issue](https://github.com/edusantana/indeva-lojas/issues/1) para commitar com rastreabilidade.

        $ git add -A :/
        $ git status
        No ramo master
        Your branch is up-to-date with 'origin/master'.
        Mudanças a serem submetidas:
          (use "git reset HEAD <file>..." to unstage)
                new file:   .rspec
                new file:   Dockerfile
                modified:   Gemfile
                modified:   Gemfile.lock
                new file:   spec/rails_helper.rb
                new file:   spec/spec_helper.rb
        $ git commit -m "Instalando RSpec #1
        > 
        > closes #1"
        [master f2a70ef] Instalando RSpec #1
         6 files changed, 161 insertions(+), 1 deletion(-)
         create mode 100644 .rspec
         create mode 100644 Dockerfile
         create mode 100644 spec/rails_helper.rb
         create mode 100644 spec/spec_helper.rb
        dudu@eduardo-u16:/home/alexandre/w/indeva/indeva-lojas$ git push
        Counting objects: 9, done.
        Delta compression using up to 4 threads.
        Compressing objects: 100% (8/8), done.
        Writing objects: 100% (9/9), 3.57 KiB | 0 bytes/s, done.
        Total 9 (delta 3), reused 0 (delta 0)
        remote: Resolving deltas: 100% (3/3), completed with 3 local objects.
        To git@github.com:edusantana/indeva-lojas.git
           e7070b5..f2a70ef  master -> master

LEMBRETE: Notificar que https://relishapp.com/rspec/rspec-rails/docs está com documentação desatualizada em vez de `script/rails generate rspec:install`, deveria ser: `bin/rails generate rspec:install`


## Iniciando o entendimento da aplicação

Eu tenho algumas dúvidas, acho que o apropriado seria entrar em contato com o cliente para resolvê-las, no entanto, vou primeiro escrever vários cenários, para poder otimizar o tempo com ele, e tirar as dúvidas de uma única vez.

Estou inclinado a utilizar BDD+Capybara, pois o poderia escrever as features em portugues e utilizá-las para dialogar com o cliente. Antes de ir direto para os cenários, vou verificar se essa alternativa ainda é a melhor prática ou existem outras mais apropriadas. Vou pesquisar um pouco sobre *continuous deployment* e *BDD*.

- [artigo 1](https://technologyconversations.com/2014/07/23/bdd-behavior-driven-development-missing-piece-in-the-continuous-integration-puzzle/)
- [artigo 2](https://www.rebaca.com/wp-content/uploads/2017/03/Behavior-Driven-Development-BDDandContinuous-Integration-Delivery-CI-CD.pdf)

Eu considero que um problema da adoção do BDD está relacionada à priorização das features realizada pelo Product Owner, pois tenho receio que se entrar em contato com o cliente ele pode querer demais e me faltar argumentos para direcioná-lo para o que é realmente essencial para o negócio dele. Vou expandir um pouco a pesquisa para verificar alguma alternativa com as metodologias Lean.

> There is nothing so useless as doing efficiently that which should not be done at all. -- Peter Drucker.

Esse trecho está no início do capítulo 7 do livro [LEAN ENTERPRISE How High Performance Organizations Innovate at Scale](http://shop.oreilly.com/product/0636920030355.do). O título do capítulo *Identify Value and Increase Flow* está em conformidade com esse pensamento que mencionei, sobre o que deve ser priorizado.

A forma como [o problema está sendo descrito no gist](https://gist.github.com/hudsonsferreira/c695a98c29212f77fc4cda9703543d70) revela que o autor tem conhecimentos de *desenvolvimento e relacionamento de banco de dados* (me faltou a palavra precisa agora).

Enfim, acho que a avaliação que estou sendo submetido consiste apenas em avaliar os conhecimentos técnicos de rails, provalmente não me caberia fazer perguntas de análise de negócios mais profundas, convencendo o Owner a priorizar outras funcionalidas. 

## Utilização do Docker em desenvolvimento

Embora eu reconheça o benefício da utilização do docker em produção e em servidores de integração, estou achando muito complexo mantê-lo no workflow do desenvolvimento.

- Com que frequência a imagem da aplicação precisa ser reconstruída?

- Como manter o desenvolvimento de aplicação ruby on rails com o docker sem instalar o ambiente de produção localmente?

Por exemplo, ao seguir [este artigo sobre utilização do docker](https://blog.codeship.com/running-rails-development-environment-docker/) a primeira instrução consistem em instalar o rails localmente. Provavelmente o artigo foi patrocinado pelo codeship, que funciona como servidor de integração, para os usuários utilizarem os seus serviços. As boas práticas de desenvolvimento ainda me permanece desconhecida.

- Como utilizar o docker em ambiente de produção quando envolve execução de comandos com geração de arquivos, como o `rails generate`?

Quando inspecionamos os arquivos Dockerfile habitualmente existe o comando `COPY . .`. Isto geralmente implica que estaremos trabalhando com uma cópia dos arquivos dentro do container. A solução apropriada envolveria algum tipo de volume ou montagem, e nestes casos, quais seria as melhores práticas?

- Como otimizar o uso de imagens Docker no desenvolvimento ruby on rails para diminuir o tempo de builds das imagens?

Para diminuir o tempo de builds, [uma alternativa](https://github.com/docker/compose/issues/3411) seria remover `bundle install` da imagem e utilizar um volume para manter os gems compilados fora das imagens. Isto seria uma boa prática? Como organizar o desenvolvimento com essa solução?

- Como utilizar o docker para desenvolvimento de aplicação que serão publicadas no Heroku?


Devido ao desconhecimento dessas respostas, vou prosseguir o desenvolvimento sem o docker.


LEMBRETE: criar essas questões no stackoverflow para obter as respostas


# Instalação

- Instalação do [rvm](https://rvm.io/rvm/install), [ruby](https://rvm.io/rvm/install) e rails

## Requisitos

Vamos rever os requisitos:

- O proprietário precisa se autenticar no sistema
- O proprietário pode visualizar apenas as metas das suas lojas
- Visualizar o valor total da meta por vendedor

A aplicação está descrita [nesse gist](https://gist.github.com/hudsonsferreira/c695a98c29212f77fc4cda9703543d70).


Vamos instalar o `mini_racer` e `capybara` para os testes.

[capybara]: https://github.com/teamcapybara/capybara

