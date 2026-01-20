SELECT tbl_cliente.nome AS nome_cliente, tbl_cliente.tipo, tbl_cliente.id, tbl_venda.data_venda, 
tbl_item_venda.preco_unitario, tbl_item_venda.qtde_vendida, 
tbl_produto.descricao AS decricao_produto, tbl_fornecer_produto.preco_custo, 
tbl_fornecer_produto.prazo_entrega_dias, tbl_fornecedor.razao_social AS nome_fornecedor, tbl_fornecedor.cidade
FROM tbl_cliente 
INNER JOIN   tbl_venda
ON tbl_cliente.id = tbl_venda.id
INNER JOIN tbl_item_venda
ON tbl_venda.id = tbl_item_venda.id_venda
INNER JOIN tbl_produto
ON tbl_item_venda.id_produto = tbl_produto.id
INNER JOIN tbl_fornecer_produto
ON tbl_produto.id = tbl_fornecer_produto.id_produto
INNER JOIN tbl_fornecedor
ON tbl_fornecer_produto.id_produto = tbl_fornecedor.id;

SELECT tbl_produto.id, tbl_produto.descricao AS nome_produto, tbl_item_venda.preco_unitario,
tbl_venda.data_venda, tbl_vendedor.nome
FROM tbl_produto
INNER JOIN tbl_item_venda
ON tbl_produto.id = tbl_item_venda.id_produto
INNER JOIN tbl_venda
ON tbl_item_venda.id_venda = tbl_venda.id
INNER JOIN tbl_vendedor
ON tbl_venda.id_vendedor = tbl_vendedor.id;

SELECT c.nome, c.tipo, v.data_venda, iv.preco_unitario, iv.qtde_vendida, p.descricao AS nome_produto
FROM tbl_cliente AS c
INNER JOIN tbl_venda AS v
ON c.id = v.id_cliente
INNER JOIN tbl_item_venda AS iv
ON v.id = iv.id_venda
INNER JOIN tbl_produto AS p
ON iv.id_produto = p.id;

SELECT c.nome AS 'Nome do Cliente:', c.tipo AS 'PF / PJ', v.data_venda AS 'Data da Venda:', 
p.status_pagamento AS 'Status do Pagamento:', p.valor AS 'Valor R$:', 
p.forma_pagamento AS 'Forma de Pagamento:', p.numero_parcela AS 'Nº de Parcelas:'
FROM tbl_cliente AS c
INNER JOIN tbl_venda AS v
ON c.id = v.id_cliente
INNER JOIN tbl_pagamento AS p
ON v.id = p.id_venda
ORDER BY c.nome, v.data_venda;

SELECT c.nome AS 'Nome do Cliente:',
c.tipo AS 'PF / PJ',
SUM(p.valor) AS 'Total em Compras R$:',
COUNT(v.id) AS 'Quantidade de Vendas:'
FROM tbl_cliente AS c
INNER JOIN tbl_venda AS v
ON c.id = v.id_cliente
INNER JOIN tbl_pagamento AS p
ON v.id = p.id_venda
GROUP BY c.nome, c.tipo
ORDER BY SUM(p.valor) desc;

SELECT v.id, 1, '2025-10-25', NULL, 'PENDENTE', 'DINHEIRO',
       ROUND(SUM(iv.preco_unitario * iv.qtde_vendida), 2)
FROM tbl_venda v
JOIN tbl_item_venda iv ON iv.id_venda = v.id
WHERE v.data_venda = '2025-10-20'
GROUP BY v.id;

SELECT v.id, 1, '2025-10-26', NULL, 'PENDENTE', 'PIX',
       ROUND(SUM(iv.preco_unitario * iv.qtde_vendida), 2)
FROM tbl_venda v
JOIN tbl_item_venda iv ON iv.id_venda = v.id
WHERE v.data_venda = '2025-10-25'
GROUP BY v.id;

CREATE TEMPORARY TABLE tmp_tot AS
SELECT v.id AS id_venda,
       ROUND(SUM(iv.preco_unitario * iv.qtde_vendida), 2) AS total
FROM tbl_venda v
JOIN tbl_item_venda iv ON iv.id_venda = v.id
WHERE v.data_venda = '2025-12-10'
GROUP BY v.id;

SELECT t.id_venda,
       p.numero_parcela,
       p.data_vencimento,
       'PENDENTE',
       'PARCELADO',
       CASE
           WHEN p.numero_parcela < 3 THEN ROUND(t.total / 3, 2)
           ELSE ROUND(t.total - (ROUND(t.total / 3, 2) * 2), 2)
       END AS valor
FROM tmp_tot t
CROSS JOIN (
    SELECT 1 AS numero_parcela, DATE('2025-12-10') AS data_vencimento
    UNION ALL SELECT 2, DATE('2026-01-10')
    UNION ALL SELECT 3, DATE('2026-02-10')
) p;

DROP TEMPORARY TABLE tmp_tot;