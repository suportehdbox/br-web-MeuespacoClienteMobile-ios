
IOS APP
=================================

Requisitos
-------

    - MacOS
    - Xcode
    - Cocoapods
    - Flutter SDK

Setup
-------

    - Adicione a sua de desenvolvedor pelo menu superior: Xcode → Preferences → Accounts → + button → Apple ID, ao adicionar a conta ele ira sincronizar os profiles de build da aplicação.
    - Clone o repositório do projeto ios e o flutter modules em uma mesma pasta
    - No projeto do flutter instale as dependências pelo seguinte comando: flutter build ios-framework
    - Após instalar as depedências do flutter, dentro da pasta appsegurado, execute o seguinte comando pelo terminal:  pod install
    - Esse comando irá instalar todas as dependências necessárias para executar o projeto, após concluir pode abrir o projeto pelo arquivo appsegurado.xcworkspace

Compilação para ACT/PRD
-------

    - No arquivo appsegurado/appsegurado/Models/BaseModel.h, temos na linha 11, a definição da variavel PRODUCTION se definida como TRUE irá compilar para produção, caso seja FALSE, irá compilar para ACT
    - Nessa estrutura também temos os produtos Liberty e Aliro, entao ao compilar é possível escolher os apps que deseja compilar, além disso é ai que alteramos o app escolhido para compilar, no caso isDefault.set(true) trocando entre os flavors você define qual será compilado e executado em tempo de execução/depuração.
    - A definição das duas marcas se baseia no uso de Targets, temos o appsegurado e o Aliro, trocando o target ao definido ao lado do play podemos escolher qual marca iremos compilar

Publicação Loja:
-------

    - Verifique o ambiente selecionado, a versão e o build correto, se versão e build ja existirem em na Apple não será permitido subir o app, para subir execute os seguintes passos:
    - Selecione o target correto → Product → Archive
    - Esse processo demora alguns minutos, para ser concluido irá abrir uma janela com a lista de compilações, selecione a versão compilada → Distribute App, a nova janela que irá abrir é apenas dar "Next" até concluir o upload. 

Pontos imortantes:
-------

    - Diferente do Android o iOS automaticamente pode debugar a qualquer momento, basta colocar um breakpoint
    - Ao criar ou adicionar um arquivo, o xcode irá perguntar em qual target deseja adicionar, pode ser para ambos ou no caso de imagens especificas você pode adicionar apeanas para a marca respecitiva
    - O projeto está estruturado em MVC, então temos as pasta de Model com regras e conexões, as Controllers fazendo passagem entre a view e a model, que são os UIViewController, os controller implementam todos os delegates e data sources, as views tem exclusiva responsabilidade de ajuste de layout.