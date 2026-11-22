
-- ==========================================
-- R1 - REGISTRO TRANSACIONAL DE PEDIDO
-- ==========================================

BEGIN;

DO $$
DECLARE
    v_pedido INTEGER;
    v_linhas INTEGER;
BEGIN

    -- 1. Criar pedido
    INSERT INTO pedidos (id_cliente, status)
    VALUES (1, 'APROVADO')
    RETURNING id_pedido INTO v_pedido;

    -- 2. Inserir itens
    INSERT INTO itens_pedido
        (id_pedido, id_produto, quantidade, preco_unitario)
    VALUES
        (v_pedido, 'CEL001', 2, 1500.00),
        (v_pedido, 'LIV001', 1, 80.00);

    -- 3. Baixar estoque do celular
    UPDATE produtos_estoque
    SET quantidade_estoque = quantidade_estoque - 2
    WHERE id_produto = 'CEL001'
      AND quantidade_estoque >= 2;

    GET DIAGNOSTICS v_linhas = ROW_COUNT;

    IF v_linhas <> 1 THEN
        RAISE EXCEPTION 'Estoque insuficiente para CEL001';
    END IF;

    -- 4. Baixar estoque do livro
    UPDATE produtos_estoque
    SET quantidade_estoque = quantidade_estoque - 1
    WHERE id_produto = 'LIV001'
      AND quantidade_estoque >= 1;

    GET DIAGNOSTICS v_linhas = ROW_COUNT;

    IF v_linhas <> 1 THEN
        RAISE EXCEPTION 'Estoque insuficiente para LIV001';
    END IF;

    -- 5. Registrar pagamento
    INSERT INTO pagamentos
        (id_pedido, valor, forma_pagamento, status)
    VALUES
        (v_pedido, 3080.00, 'CARTAO', 'APROVADO');

    -- 6. Atualizar total
    UPDATE pedidos
    SET valor_total = 3080.00
    WHERE id_pedido = v_pedido;

    RAISE NOTICE 'Pedido % realizado com sucesso', v_pedido;

END $$;

COMMIT;
