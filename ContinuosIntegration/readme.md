<p align="center"> <img src = "https://user-images.githubusercontent.com/68132461/163346757-0757c301-4226-442f-aa6b-f75321aa10fe.png"> </p>


* <b>Versionamento:</b>

	No nosso projeto para CI temos  4 branch's sendo elas:

	<b>Main:</b> Branch de produção, responsável pelas versões finais do projeto.
Caso ocorra algum erro nesta branch é criada uma Hotfix para resolução imediato do ocorrido.
Para subir nesta branch é preciso a aprovação do Master do grupo, assim, sendo rapída a percepção de possiveis falhas.

	<b>Hotfix:</b> Como dito acima, essa branch é acionada caso ocorra algum erro na versão que esta na Main, o erro deve ser logo
encontrado e corrigido utilizando essa branch. Após corrigido o erro é feito um git push nesta branch verificado os erros e depois 
um merge é realizado na main, porem, deve ser feita a aprovação do master.

	<b>Dev:</b> Branch de desenvolvimento, utilizada pelos desenvolvedores de forma a centralizar as mudanças realizadas nas features.
	Todo push para esta branch passa por testes unitários e de Integração, possibilitando identificar falhas em caso de features incompatives,
	e assim corrigi-las rapidamente. Após os testes serem realizados nesta branch e estiverem corretos um merge na branch Main é realizado.

	<b>Feature:</b> Branch para desenvolvimento de novas atualizações para a branch Dev, cada desenvolvedor cria uma nova feature para uma nova atualização,
	é importante sempre dar push a cada atualização para não haver mudanças grandes no projeto, impossibilitando assim a correção rapída de erros.
	Após o push nesta branch os testes são realizados e se tudo estiver certo um merge com a branch Dev é realizado.

	Para a criação dos testes automatizados utilizamos o próprio GitHub Actions que permite uma centralização de ferramentas e controle dos scripts de testes.
Abaixo temos nossos workflows utilizados: 

	<details>
	<summary>Workflow Branch Main:</summary>

		name: Java CI

		on:
		  push:
			branches: [ main ]
		  pull_request:
			branches: [ main ]

		jobs:
		  build:

			runs-on: ubuntu-latest
			environment:
			  name: main

			steps:
			- uses: actions/checkout@v3
			- name: Set up JDK 1.11
			  uses: actions/setup-java@v2
			  with:
				java-version: '11'
				distribution: 'adopt'
				
			- name: Clean
			  run: mvn clean 

			- name: Build
			  run: mvn --batch-mode -DskipTests package

			- name: Tests
			  run: mvn --batch-mode -Dmaven.test.failure.ignore=true test

			- name: Build and push Docker Image
			  uses: mr-smithers-excellent/docker-build-push@v4
			  with:
				  image: mdices/api5sem
				  registry: docker.io
				  username: ${{ secrets.DOCKER_USERNAME }}
				  password: ${{ secrets.DOCKER_PASSWORD }}
	</details>

	<details>
	<summary>Workflow Branch Hotfix:</summary>

		name: Java CI Hotfix

		on:
		  push:
			branches: [ hotfix/* ]
		  pull_request:
			branches: [ hotfix/* ]

		jobs:
		  build:

			runs-on: ubuntu-latest

			steps:
			- uses: actions/checkout@v3
			- name: Set up JDK 1.11
			  uses: actions/setup-java@v2
			  with:
				java-version: '11'
				distribution: 'adopt'

			- name: Build
			  run: mvn --batch-mode -DskipTests package

			- name: Test
			  run: mvn --batch-mode -Dmaven.test.failure.ignore=true test
	</details>

	<details>
	<summary>Workflow Branch Dev:</summary>

		name: Java CI Dev

		on:
		  push:
			branches: [ dev ]
		  pull_request:
			branches: [ dev ]

		jobs:
		  build:

			runs-on: ubuntu-latest
			environment:
			  name: dev
			  
			steps:
			- uses: actions/checkout@v3
			- name: Set up JDK 1.11
			  uses: actions/setup-java@v2
			  with:
				java-version: '11'
				distribution: 'adopt'
			
			- name: Clean
			  run: mvn clean 
			  
			- name: Build
			  run: mvn --batch-mode -DskipTests package

			- name: Test
			  run: mvn --batch-mode -Dmaven.test.failure.ignore=true test
	</details>
		
	<details>
	<summary>Workflow Branch Feature:</summary>

		```
		name: Java CI Feature

		on:
		  push:
			branches: [ feature/* ]
		  pull_request:
			branches: [ feature/* ]

		jobs:
		  build:

			runs-on: ubuntu-latest

			steps:
			- uses: actions/checkout@v3
			- name: Set up JDK 1.11
			  uses: actions/setup-java@v2
			  with:
				java-version: '11'
				distribution: 'adopt'

			- name: Test
			  run: mvn --batch-mode -Dmaven.test.failure.ignore=true test
		 ```
	</details>

* <b>Testes</b>

	- Unitarios: Os testes unitários foram criado utilizando o JUnit e colocados no repositório do projeto.
	Para execução dos testes utilizamos Maven chamando quando rodamos os workflows na Feature, Dev e Hotfix.

	- Integração: Os testes de integração foram criados utilizando Selenium e colocados no repositório do projeto.
	Para execução dos testes utilizamos Maven rodando nos workflows das branchs Feature, Dev e Hotfix.
	
	Abaixo Código que executa os testes:
	
		
		name: Test
		  run: mvn --batch-mode -Dmaven.test.failure.ignore=true test
		
* <b>Migration</b>
	
	- Para o banco de dados utilizamos o Flyway para versionar novas atualizações, permitindo assim que todos estejam utilizando uma mesma versão
	para todos os desenvolvedores. O repositório de versões se encontra dentro do projeto no seguinte caminho:
	
	src > main > resources > db > migration > V1_database.sql
	
	- A cada nova atualização no banco um novo arquivo deve ser criado seguindo o modelo de nome "V2_atualizacao.sql", e assim o Flyway implementará
	a nova atualização.
	
* <b>Tecnologias Utilizadas</b>

	- GitHub: Versionamento
	- Maven: Build
	- JUnit: Testes Unitários
	- Selenium: Testes de Integração
	- Flyway: Migration BD
	- Docker: Deploy
	- Heroku: Hospedagem do sistema
