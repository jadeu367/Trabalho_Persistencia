// ==========================================
// MARKETPLACE
// REQUISITO R7 - NEO4J
// Demonstração das recomendações
// ==========================================

// ------------------------------------------
// 1. "Quem comprou este produto também comprou"
//    Produto de referência: CEL001 (Smartphone Galaxy)
//    Caminho: produto <- cliente -> outro produto
// ------------------------------------------
MATCH (p:Produto {id: 'CEL001'})<-[:COMPROU]-(c:Cliente)-[:COMPROU]->(outro:Produto)
WHERE outro <> p
RETURN outro.id AS produto, outro.nome AS nome,
       count(DISTINCT c) AS clientes_que_compraram_ambos
ORDER BY clientes_que_compraram_ambos DESC, nome
LIMIT 5;

// ------------------------------------------
// 2. Clientes com histórico parecido com o de USR001 (João Silva)
//    Similaridade = quantidade de produtos comprados em comum
// ------------------------------------------
MATCH (eu:Cliente {id: 'USR001'})-[:COMPROU]->(p:Produto)<-[:COMPROU]-(outro:Cliente)
RETURN outro.id AS cliente, outro.nome AS nome,
       count(DISTINCT p) AS produtos_em_comum,
       collect(DISTINCT p.nome) AS quais
ORDER BY produtos_em_comum DESC, nome;

// ------------------------------------------
// 3. "Clientes com histórico parecido com o seu compraram isto"
//    Considera parecido quem tem 2 ou mais produtos em comum com USR001
//    e recomenda o que eles compraram e USR001 ainda não comprou.
// ------------------------------------------
MATCH (eu:Cliente {id: 'USR001'})-[:COMPROU]->(p:Produto)<-[:COMPROU]-(parecido:Cliente)
WITH eu, parecido, count(DISTINCT p) AS em_comum
WHERE em_comum >= 2
MATCH (parecido)-[:COMPROU]->(rec:Produto)
WHERE NOT EXISTS { (eu)-[:COMPROU]->(rec) }
RETURN rec.id AS produto, rec.nome AS nome,
       count(DISTINCT parecido) AS clientes_parecidos,
       sum(em_comum) AS pontuacao
ORDER BY pontuacao DESC, nome
LIMIT 5;
