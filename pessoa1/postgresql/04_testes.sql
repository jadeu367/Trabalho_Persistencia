
-- ==========================================
-- TESTE DE ATOMICIDADE
-- Simular compra com estoque insuficiente
-- ==========================================

BEGIN;

DO $$
DECLARE
    v_pedido INTEGER;
    v_linhas INTEGER;
BEGIN

    -- Criar pedido
    INSERT INTO pedidos (id_cliente, status)
    VALUES (1, 'APROVADO')
    RETURNING id_pedido INTO v_pedido;

    -- Inserir item
    INSERT INTO itens_pedido
        (id_pedido, id_produto, quantidade, preco_unitario)
    VALUES
        (v_pedido, 'CEL001', 100, 1500.00);

    -- Tentar baixar 100 unidades
    UPDATE produtos_estoque
    SET quantidade_estoque = quantidade_estoque - 100
    WHERE id_produto = 'CEL001'
      AND quantidade_estoque >= 100;

    GET DIAGNOSTICS v_linhas = ROW_COUNT;

    IF v_linhas <> 1 THEN
        RAISE EXCEPTION 'TESTE: Estoque insuficiente';
    END IF;

    -- Pagamento não deve ser registrado
    INSERT INTO pagamentos
        (id_pedido, valor, forma_pagamento, status)
    VALUES
        (v_pedido, 150000.00, 'CARTAO', 'APROVADO');

END $$;

COMMIT;
