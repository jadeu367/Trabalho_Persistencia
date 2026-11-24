# Neo4j — R7 (Recomendações)

## Requisito

> R7. Responder "quem comprou este produto também comprou" e "clientes com histórico parecido com o seu compraram isto".

## Por que Neo4j

As duas perguntas são de **relacionamento entre entidades**: partem de um produto (ou de um cliente),
caminham até os clientes que o compraram e voltam para outros produtos. Em um banco de grafos esse
percurso é feito seguindo as arestas a partir do nó de origem (*index-free adjacency*), sem os
*self-joins* em cadeia que a mesma consulta exigiria na tabela `itens_pedido` do PostgreSQL. O custo
da consulta depende da vizinhança visitada, e não do tamanho total da base.

## Modelo do grafo

```text
(:Cliente {id, nome}) -[:COMPROU {data, quantidade}]-> (:Produto {id, nome, categoria, preco})
(:Produto) -[:PERTENCE_A]-> (:Categoria {nome})
```

- Os ids de produto seguem o catálogo do MongoDB (`CEL001`, `LIV001`, `CAM001`...).
- Os ids de cliente seguem o padrão do Redis e da Cassandra (`USR001`, `USR002`...).
- A relação `COMPROU` representa o histórico de pedidos registrado no PostgreSQL (R1).
- Restrições de unicidade em `Cliente.id`, `Produto.id` e `Categoria.nome` garantem que não haja nós duplicados e criam índices para as buscas por id.

Carga: 10 clientes, 11 produtos, 4 categorias e 28 compras.

## Execução

**1. Subir o Neo4j** (o serviço está no perfil `outros` do `docker-compose.yml`):

```bash
docker compose --profile outros up -d neo4j
```

Aguarde cerca de 30 segundos até o Neo4j terminar de iniciar (`docker compose logs neo4j` deve mostrar `Started.`).

No Windows, rode os comandos dos passos 2 e 3 pelo **Git Bash** ou pelo **CMD**. O PowerShell não aceita o redirecionamento `<`; nele, use `cmd /c "comando"`.

**2. Criar o grafo e carregar os dados:**

```bash
docker compose exec -T neo4j cypher-shell -u neo4j -p marketplace123 < pessoa3/neo4j/01_criacao_carga.cypher
```

**3. Executar as recomendações:**

```bash
docker compose exec -T neo4j cypher-shell -u neo4j -p marketplace123 < pessoa3/neo4j/02_recomendacoes.cypher
```

**4. (Opcional) Visualizar o grafo** em `http://localhost:7474` (usuário `neo4j`, senha `marketplace123`):

```cypher
MATCH (c:Cliente)-[r:COMPROU]->(p:Produto) RETURN c, r, p
```

## Resultados esperados

**Consulta 1 — Quem comprou o Smartphone Galaxy (CEL001) também comprou:**

| produto | nome | clientes_que_compraram_ambos |
|---|---|---|
| CAP001 | Capa Protetora | 3 |
| CAR001 | Carregador Turbo | 2 |
| FON001 | Fone Bluetooth | 2 |
| LIV001 | Engenharia de Software | 1 |

**Consulta 2 — Clientes com histórico parecido com o de João Silva (USR001):**

| cliente | nome | produtos_em_comum |
|---|---|---|
| USR003 | Pedro Santos | 3 |
| USR004 | Ana Costa | 2 |
| USR002 | Maria Oliveira | 2 |
| USR009 | Bruno Alves | 1 |

**Consulta 3 — Clientes parecidos com João compraram isto** (parecido = 2 ou mais produtos em comum; só entram produtos que ele ainda não comprou):

| produto | nome | clientes_parecidos | pontuacao |
|---|---|---|---|
| CAR001 | Carregador Turbo | 2 | 5 |
| CEL002 | Smartphone Moto G | 1 | 2 |

O Bruno Alves (USR009) tem só 1 produto em comum, então fica abaixo do limite e o livro que ele comprou não é recomendado. A pontuação soma a quantidade de produtos em comum de cada cliente parecido que comprou o item, de modo que recomendações vindas de clientes mais parecidos pesam mais.
