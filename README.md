# Sistema de Gestão de Proponentes

Sistema desenvolvido para gerenciar proponentes, calcular descontos de INSS e gerar relatórios.

## 🚀 Tecnologias

- Ruby 3.2.9
- Rails 7.1.2
- PostgreSQL
- Elasticsearch
- Bootstrap 5
- Stimulus.js
- Turbo
- Slim

## 📋 Pré-requisitos

- Docker
- Docker Compose

## 🔧 Instalação e Uso

1. Clone o repositório:
```bash
git clone https://github.com/seu-usuario/desafio_impulso.git
cd desafio_impulso
```

2. Configure o ambiente:
```bash
cp .env.example .env
```

3. Construa e inicie os containers:
```bash
docker compose build
docker compose up
```

4. Em outro terminal, execute as migrações e crie o banco de dados:
```bash
docker compose exec desafio_impulso rails db:create db:migrate
```

5. Popule o banco de dados com dados iniciais:
```bash
docker compose exec desafio_impulso rails dev:prime
```

6. Acesse a aplicação em http://localhost:3333

## 👤 Autenticação

O sistema utiliza o Devise para autenticação. Você pode usar as seguintes credenciais para teste:

- Email: test@test.com
- Senha: 123456

## 📊 Tabela do INSS 2023

| Faixa Salarial | Alíquota |
|----------------|----------|
| Até R$ 1.412,00 | 7,5% |
| De R$ 1.412,01 a R$ 2.666,68 | 9% |
| De R$ 2.666,69 a R$ 4.000,03 | 12% |
| De R$ 4.000,04 a R$ 7.786,02 | 14% |

## 🧪 Testes

Para executar os testes, siga os passos abaixo:

1. Entre no container:
```bash
docker compose exec desafio_impulso bash
```

2. Crie o banco de dados de teste:
```bash
rails db:create db:migrate RAILS_ENV=test
```

3. Execute os testes:
```bash
# Executar todos os testes
rails test

# Executar testes específicos
rails test test/models/proponent_test.rb
rails test test/controllers/proponents_controller_test.rb

# Executar testes com detalhes
rails test --verbose

# Executar testes com coverage
COVERAGE=true rails test
```

## 📝 Convenções de Código

- Ruby Style Guide
- ESLint para JavaScript
- Slim para templates
- BEM para CSS

## 📄 Licença

Este projeto está sob a licença MIT. Veja o arquivo [LICENSE](LICENSE) para mais detalhes.

## 🤝 Contribuição

1. Faça o fork do projeto
2. Crie uma branch para sua feature (`git checkout -b feature/AmazingFeature`)
3. Commit suas mudanças (`git commit -m 'Add some AmazingFeature'`)
4. Push para a branch (`git push origin feature/AmazingFeature`)
5. Abra um Pull Request

## 📄 Licença

Este projeto está sob a licença MIT. Veja o arquivo [LICENSE](LICENSE) para mais detalhes.

## 👥 Autores

* **Seu Nome** - *Desenvolvimento* - [seu-usuario](https://github.com/seu-usuario)

## 🙏 Agradecimentos

* [Rails](https://rubyonrails.org/)
* [Bootstrap](https://getbootstrap.com/)
* [Stimulus](https://stimulus.hotwired.dev/)
* [Turbo](https://turbo.hotwired.dev/)
