// ==========================================
// MARKETPLACE
// REQUISITO R7 - NEO4J
// Criação e carga do grafo de compras
// ==========================================
//
// Modelo:
//   (:Cliente {id, nome})
//   (:Produto {id, nome, categoria, preco})
//   (:Categoria {nome})
//   (:Cliente)-[:COMPROU {data, quantidade}]->(:Produto)
//   (:Produto)-[:PERTENCE_A]->(:Categoria)
//
// Os ids de produto seguem o catálogo do MongoDB (CEL001, LIV001, CAM001...)
// e os ids de cliente seguem o padrão usado no Redis e na Cassandra (USR001...).

// Limpar dados anteriores para repetir os testes
MATCH (n) DETACH DELETE n;

// Restrições de unicidade (também criam índices para as buscas por id)
CREATE CONSTRAINT cliente_id IF NOT EXISTS FOR (c:Cliente) REQUIRE c.id IS UNIQUE;
CREATE CONSTRAINT produto_id IF NOT EXISTS FOR (p:Produto) REQUIRE p.id IS UNIQUE;
CREATE CONSTRAINT categoria_nome IF NOT EXISTS FOR (c:Categoria) REQUIRE c.nome IS UNIQUE;

// CATEGORIAS
UNWIND ['Celular', 'Acessório', 'Livro', 'Vestuário'] AS nome
MERGE (:Categoria {nome: nome});

// PRODUTOS
UNWIND [
  {id: 'CEL001', nome: 'Smartphone Galaxy',      categoria: 'Celular',   preco: 1500.00},
  {id: 'CEL002', nome: 'Smartphone Moto G',      categoria: 'Celular',   preco: 1200.00},
  {id: 'CAP001', nome: 'Capa Protetora',         categoria: 'Acessório', preco: 49.90},
  {id: 'FON001', nome: 'Fone Bluetooth',         categoria: 'Acessório', preco: 199.90},
  {id: 'CAR001', nome: 'Carregador Turbo',       categoria: 'Acessório', preco: 89.90},
  {id: 'LIV001', nome: 'Engenharia de Software', categoria: 'Livro',     preco: 80.00},
  {id: 'LIV002', nome: 'Banco de Dados NoSQL',   categoria: 'Livro',     preco: 95.00},
  {id: 'CAM001', nome: 'Camiseta Básica',        categoria: 'Vestuário', preco: 59.90},
  {id: 'CAM002', nome: 'Camiseta Estampada',     categoria: 'Vestuário', preco: 69.90},
  {id: 'BON001', nome: 'Boné Esportivo',         categoria: 'Vestuário', preco: 39.90},
  {id: 'TEN001', nome: 'Tênis de Corrida',       categoria: 'Vestuário', preco: 299.90}
] AS p
MERGE (prod:Produto {id: p.id})
SET prod.nome = p.nome, prod.categoria = p.categoria, prod.preco = p.preco
WITH prod, p
MATCH (cat:Categoria {nome: p.categoria})
MERGE (prod)-[:PERTENCE_A]->(cat);

// CLIENTES
UNWIND [
  {id: 'USR001', nome: 'João Silva'},
  {id: 'USR002', nome: 'Maria Oliveira'},
  {id: 'USR003', nome: 'Pedro Santos'},
  {id: 'USR004', nome: 'Ana Costa'},
  {id: 'USR005', nome: 'Lucas Pereira'},
  {id: 'USR006', nome: 'Juliana Lima'},
  {id: 'USR007', nome: 'Rafael Souza'},
  {id: 'USR008', nome: 'Camila Rocha'},
  {id: 'USR009', nome: 'Bruno Alves'},
  {id: 'USR010', nome: 'Fernanda Dias'}
] AS c
MERGE (cli:Cliente {id: c.id})
SET cli.nome = c.nome;

// COMPRAS (histórico de pedidos vindo do PostgreSQL)
UNWIND [
  {c: 'USR001', p: 'CEL001', data: '2026-10-02', qtd: 1},
  {c: 'USR001', p: 'CAP001', data: '2026-10-02', qtd: 1},
  {c: 'USR001', p: 'FON001', data: '2026-10-15', qtd: 1},

  {c: 'USR002', p: 'CEL001', data: '2026-10-05', qtd: 1},
  {c: 'USR002', p: 'CAP001', data: '2026-10-05', qtd: 2},
  {c: 'USR002', p: 'CAR001', data: '2026-10-20', qtd: 1},

  {c: 'USR003', p: 'CEL001', data: '2026-10-08', qtd: 1},
  {c: 'USR003', p: 'CAP001', data: '2026-10-08', qtd: 1},
  {c: 'USR003', p: 'FON001', data: '2026-10-08', qtd: 1},
  {c: 'USR003', p: 'CAR001', data: '2026-11-01', qtd: 1},

  {c: 'USR004', p: 'CEL002', data: '2026-10-11', qtd: 1},
  {c: 'USR004', p: 'CAP001', data: '2026-10-11', qtd: 1},
  {c: 'USR004', p: 'FON001', data: '2026-10-25', qtd: 1},

  {c: 'USR005', p: 'LIV001', data: '2026-09-30', qtd: 1},
  {c: 'USR005', p: 'LIV002', data: '2026-10-12', qtd: 1},

  {c: 'USR006', p: 'LIV001', data: '2026-10-03', qtd: 1},
  {c: 'USR006', p: 'LIV002', data: '2026-10-03', qtd: 1},
  {c: 'USR006', p: 'CAM001', data: '2026-10-18', qtd: 2},

  {c: 'USR007', p: 'CAM001', data: '2026-10-07', qtd: 1},
  {c: 'USR007', p: 'CAM002', data: '2026-10-07', qtd: 1},
  {c: 'USR007', p: 'BON001', data: '2026-10-22', qtd: 1},

  {c: 'USR008', p: 'CAM001', data: '2026-10-09', qtd: 3},
  {c: 'USR008', p: 'BON001', data: '2026-10-09', qtd: 1},
  {c: 'USR008', p: 'TEN001', data: '2026-11-03', qtd: 1},

  {c: 'USR009', p: 'CEL001', data: '2026-10-14', qtd: 1},
  {c: 'USR009', p: 'LIV001', data: '2026-10-14', qtd: 1},

  {c: 'USR010', p: 'CAM002', data: '2026-10-28', qtd: 1},
  {c: 'USR010', p: 'TEN001', data: '2026-10-28', qtd: 1}
] AS compra
MATCH (cli:Cliente {id: compra.c})
MATCH (prod:Produto {id: compra.p})
MERGE (cli)-[r:COMPROU]->(prod)
SET r.data = date(compra.data), r.quantidade = compra.qtd;

// Conferir a carga
MATCH (c:Cliente) WITH count(c) AS clientes
MATCH (p:Produto) WITH clientes, count(p) AS produtos
MATCH ()-[r:COMPROU]->()
RETURN clientes, produtos, count(r) AS compras;
