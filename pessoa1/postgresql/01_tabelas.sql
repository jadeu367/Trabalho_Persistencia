
-- ==========================================
-- MARKETPLACE
-- REQUISITO R1 - POSTGRESQL
-- ==========================================

CREATE TABLE IF NOT EXISTS clientes (
    id_cliente SERIAL PRIMARY KEY,
    nome VARCHAR(150) NOT NULL,
    email VARCHAR(150) UNIQUE NOT NULL
);

CREATE TABLE IF NOT EXISTS produtos_estoque (
    id_produto VARCHAR(50) PRIMARY KEY,
    nome VARCHAR(150) NOT NULL,
    quantidade_estoque INTEGER NOT NULL
        CHECK (quantidade_estoque >= 0)
);

CREATE TABLE IF NOT EXISTS pedidos (
    id_pedido SERIAL PRIMARY KEY,
    id_cliente INTEGER NOT NULL
        REFERENCES clientes(id_cliente),
    data_pedido TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    status VARCHAR(30) NOT NULL DEFAULT 'PENDENTE',
    valor_total NUMERIC(12,2) NOT NULL DEFAULT 0
);

CREATE TABLE IF NOT EXISTS itens_pedido (
    id_item SERIAL PRIMARY KEY,
    id_pedido INTEGER NOT NULL
        REFERENCES pedidos(id_pedido),
    id_produto VARCHAR(50) NOT NULL
        REFERENCES produtos_estoque(id_produto),
    quantidade INTEGER NOT NULL CHECK (quantidade > 0),
    preco_unitario NUMERIC(12,2) NOT NULL
        CHECK (preco_unitario >= 0)
);

CREATE TABLE IF NOT EXISTS pagamentos (
    id_pagamento SERIAL PRIMARY KEY,
    id_pedido INTEGER NOT NULL
        REFERENCES pedidos(id_pedido),
    valor NUMERIC(12,2) NOT NULL,
    forma_pagamento VARCHAR(50) NOT NULL,
    status VARCHAR(30) NOT NULL
);

-- Índices para relacionamentos e consultas
CREATE INDEX IF NOT EXISTS idx_pedidos_cliente
ON pedidos(id_cliente);

CREATE INDEX IF NOT EXISTS idx_itens_pedido
ON itens_pedido(id_pedido);

CREATE INDEX IF NOT EXISTS idx_itens_produto
ON itens_pedido(id_produto);
