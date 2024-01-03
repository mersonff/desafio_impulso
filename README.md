# Desafio Impulso

Desenvolva uma aplicação "Desconto INSS" utilizando o Rails, atendendo aos seguintes requisitos:

- **Rails 5 ou superior**
- **PostgreSQL**
- **Bootstrap**
- **Chart.js**
- **Rubocop Rails**
- **Kaminari**
- **Redis**
- **Sidekiq**

## Instalando a Aplicação

Para instalar o projeto, siga estas etapas:

Setando o .env
```
copie o arquivo .env.example com o nome .env e modifique onde necessário
```

```
docker compose build
docker compose up
```

## Usando

```
Acesse o projeto em http://localhost:3333

OBS: no primeiro acesso, pode ser necessário rodar o comando abaixo para criar o banco de dados e rodar as migrations

rails db:create db:migrate
```

## Testes

No terminal
```
Entre no container do projeto com o comando:
docker compose exec -it desafio_impulso bash

Rode os testes com o comando:
rspec
```

## Autenticação
```
O projeto utiliza o devise para autenticação. Caso não queira criar um usuário, pode utilizar o usuário padrão:
email: test@test.com
senha: 123456
```
