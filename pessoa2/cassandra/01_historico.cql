-- R6 - Historico de navegacao por usuario
CREATE KEYSPACE IF NOT EXISTS marketplace
WITH replication = {'class': 'SimpleStrategy', 'replication_factor': 1};

USE marketplace;

CREATE TABLE IF NOT EXISTS historico_usuario (
    usuario_id text,
    data_evento timestamp,
    tipo_evento text,
    produto_id text,
    detalhes text,
    PRIMARY KEY (usuario_id, data_evento)
) WITH CLUSTERING ORDER BY (data_evento DESC);

INSERT INTO historico_usuario (usuario_id, data_evento, tipo_evento, produto_id, detalhes)
VALUES ('USR001', toTimestamp(now()), 'visualizacao', 'PROD001', 'Visualizou produto');

INSERT INTO historico_usuario (usuario_id, data_evento, tipo_evento, produto_id, detalhes)
VALUES ('USR001', toTimestamp(now()), 'busca', null, 'Busca por smartphone');

INSERT INTO historico_usuario (usuario_id, data_evento, tipo_evento, produto_id, detalhes)
VALUES ('USR002', toTimestamp(now()), 'clique', 'PROD002', 'Clicou no produto');

SELECT * FROM historico_usuario WHERE usuario_id = 'USR001';
