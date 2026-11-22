
-- CLIENTES
INSERT INTO clientes (nome, email)
VALUES
('João Silva', 'joao@email.com'),
('Maria Oliveira', 'maria@email.com')
ON CONFLICT (email) DO NOTHING;

-- PRODUTOS E ESTOQUE
INSERT INTO produtos_estoque
(id_produto, nome, quantidade_estoque)
VALUES
('CEL001', 'Smartphone Galaxy', 10),
('LIV001', 'Engenharia de Software', 20),
('CAM001', 'Camiseta Básica', 30)
ON CONFLICT (id_produto) DO NOTHING;

-- Conferir os dados
SELECT * FROM clientes;

SELECT * FROM produtos_estoque;
