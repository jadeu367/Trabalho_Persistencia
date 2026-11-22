# Projeto Marketplace — Persistência de Dados

## 1. Sobre o projeto

Este projeto tem como objetivo implementar uma estrutura de persistência de dados para um sistema Marketplace, utilizando diferentes bancos de dados de acordo com as necessidades de armazenamento e consulta.

A implementação da Pessoa 1 contempla PostgreSQL, MongoDB e a integração entre MongoDB e Redis.

## 2. Tecnologias utilizadas

- **PostgreSQL:** armazenamento relacional de clientes, produtos em estoque, pedidos, itens e pagamentos.
- **MongoDB:** armazenamento do catálogo de produtos com atributos específicos para cada categoria.
- **Redis:** armazenamento dos produtos organizados por marca, permitindo consultas rápidas.
- **Docker Compose:** inicialização e gerenciamento dos bancos de dados.

## 3. Estrutura dos arquivos

```text
Trabalho_Persistencia/
│
├── docker-compose.yml
├── README.md
│
└── pessoa1/
    ├── postgresql/
    │   ├── 01_tabelas.sql
    │   ├── 02_dados.sql
    │   ├── 03_pedidos.sql
    │   └── 04_testes.sql
    │
    ├── mongodb/
    │   ├── 01_catalogo.js
    │   └── 02_consultas.js
    │
    └── redis-integracao/
        └── 01_produtos_por_marca.js
```

## 4. Inicialização do ambiente

Para iniciar os bancos de dados, execute na raiz do repositório:

```bash
docker compose up -d
```

Para verificar se os serviços estão funcionando:

```bash
docker compose ps
```

## 5. PostgreSQL — R1

O PostgreSQL é responsável pelo gerenciamento das operações de pedidos e estoque.

### Funcionalidades implementadas

- Criação das tabelas de clientes, produtos, pedidos, itens e pagamentos.
- Relacionamentos entre as tabelas por meio de chaves primárias e estrangeiras.
- Registro de pedidos e respectivos itens.
- Registro de pagamentos.
- Atualização do estoque durante a realização de pedidos.
- Proteção contra compras com quantidade superior ao estoque disponível.

### Execução dos scripts

**1. Criar as tabelas:**

```bash
docker compose exec -T postgres psql -v ON_ERROR_STOP=1 -U admin -d marketplace < pessoa1/postgresql/01_tabelas.sql
```

**2. Inserir os dados iniciais:**

```bash
docker compose exec -T postgres psql -v ON_ERROR_STOP=1 -U admin -d marketplace < pessoa1/postgresql/02_dados.sql
```

**3. Registrar um pedido:**

```bash
docker compose exec -T postgres psql -v ON_ERROR_STOP=1 -U admin -d marketplace < pessoa1/postgresql/03_pedidos.sql
```

**4. Testar a proteção do estoque:**

```bash
docker compose exec -T postgres psql -v ON_ERROR_STOP=1 -U admin -d marketplace < pessoa1/postgresql/04_testes.sql
```

O último script realiza uma tentativa de compra superior à quantidade disponível. A operação deve ser bloqueada para impedir inconsistências no estoque.

**Importante:** os scripts de dados e pedidos podem inserir registros e alterar o estoque. Não devem ser executados repetidamente sem verificar o estado atual do banco.

## 6. MongoDB — R2

O MongoDB é utilizado para armazenar o catálogo de produtos.

Sua estrutura permite que cada categoria possua atributos diferentes, sem exigir que todos os produtos tenham os mesmos campos.

### Exemplos de categorias

| Produto | Categoria | Atributos específicos |
|---|---|---|
| Smartphone Galaxy | Celular | Memória RAM, armazenamento e tela |
| Engenharia de Software | Livro | ISBN, páginas e autor |
| Camiseta Básica | Camiseta | Tamanho, cor e material |

### Execução dos scripts

**1. Criar e cadastrar os produtos:**

```bash
docker compose exec -T mongodb mongosh --quiet marketplace < pessoa1/mongodb/01_catalogo.js
```

**2. Executar as consultas:**

```bash
docker compose exec -T mongodb mongosh --quiet marketplace < pessoa1/mongodb/02_consultas.js
```

As consultas permitem visualizar o catálogo completo, pesquisar produtos por categoria e marca e localizar produtos por seus atributos.

## 7. Integração MongoDB com Redis — R8

A integração utiliza o catálogo armazenado no MongoDB como fonte dos dados e envia as informações ao Redis.

Os produtos são organizados por marca utilizando conjuntos (Sets) e hashes (Hashes).

### Funcionamento

- `SADD`: associa os identificadores dos produtos às suas respectivas marcas.
- `HSET`: armazena os detalhes individuais de cada produto, como nome, preço, marca e categoria.

### Executar a integração

Na raiz do projeto, execute:

```bash
docker compose exec -T mongodb mongosh --quiet --eval "$(cat pessoa1/redis-integracao/01_produtos_por_marca.js)" | grep -E '^(SADD|HSET) ' | docker compose exec -T redis redis-cli
```

### Consultar os produtos por marca

```bash
docker compose exec redis redis-cli SMEMBERS marca:MAR001:produtos
```

```bash
docker compose exec redis redis-cli SMEMBERS marca:MAR002:produtos
```

```bash
docker compose exec redis redis-cli SMEMBERS marca:MAR003:produtos
```

### Consultar os detalhes de um produto

```bash
docker compose exec redis redis-cli HGETALL produto:CEL001
```

A integração permite consultar os produtos por marca e recuperar rapidamente suas informações armazenadas no Redis.

## 8. Testes e validação

Foram realizados testes para verificar:

- Criação das tabelas e relacionamentos no PostgreSQL.
- Registro de pedidos e itens.
- Atualização do estoque após a realização de pedidos.
- Bloqueio de compras acima da quantidade disponível.
- Cadastro e consulta de produtos no MongoDB.
- Organização dos produtos por marca no Redis.
- Recuperação dos detalhes individuais dos produtos no Redis.

## 9. Considerações finais

A implementação utiliza diferentes tecnologias de persistência, aproveitando as características de cada banco de dados.

O PostgreSQL garante a consistência das operações relacionais e transacionais, o MongoDB oferece flexibilidade na estrutura do catálogo e o Redis permite consultas rápidas dos produtos organizados por marca.