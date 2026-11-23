# Redis e Cassandra

## R3 - Sessao

```bash
docker compose exec -T mongodb mongosh --quiet --eval "$(cat pessoa2/redis/01_sessoes.js)" | docker compose exec -T redis redis-cli
```

## R4 - Carrinho
O carrinho utiliza Hash para guardar produtos e quantidades.

```bash
docker compose exec -T mongodb mongosh --quiet --eval "$(cat pessoa2/redis/02_carrinho.js)" | docker compose exec -T redis redis-cli
```

## R5 - Visualizacoes
O script incrementa visualizacoes e organiza um ranking com Sorted Sets.

```bash
docker compose exec -T mongodb mongosh --quiet --eval "$(cat pessoa2/redis/03_visualizacoes.js)" | docker compose exec -T redis redis-cli
```

## R6 - Cassandra

```bash
docker compose --profile outros up -d cassandra
```

```bash
docker compose exec -T cassandra cqlsh < pessoa2/cassandra/01_historico.cql
```

```bash
docker compose exec cassandra cqlsh -e "SELECT * FROM marketplace.historico_usuario WHERE usuario_id='USR001';"
```
