INSERT INTO tbl_cliente (nome, tipo) 
VALUES ('João', 'PF'), ('Maria', 'PF'), ('José', 'PF'), 
('Carlos', 'PF'), ('Supermercado VivaMais - Ltda', 'PJ'), 
('Laticínio Ltda', 'PJ'),('Dstribuidora de Bebidas B&L', 'PJ');

INSERT INTO tbl_cliente (nome, tipo) 
VALUES ('Marina Santos', 'PF'), ('João Andrade', 'PF'), 
('Mercadinho São Lucas', 'PJ'), ('Loja Ponto Certo', 'PJ');

INSERT INTO tbl_pessoa_pf (id_cliente, cpf, data_nascimento) 
VALUES (LAST_INSERT_ID(), '55802127945', '1985-05-23'), 
(LAST_INSERT_ID(), '02240078801', '1988-07-21'), 
(LAST_INSERT_ID(), '98065031100', '1995-02-10'), 
(LAST_INSERT_ID(), '00561975100', '1981-12-10'), 
(LAST_INSERT_ID(), '05056708100', '1991-08-23');

INSERT INTO tbl_produto (descricao, preco_unitario, qtde_estoque)
VALUES ('Arroz Tipo 1 5 kg', 24.90, 80), ('Feijão Carioca 1kg', 9.90, 120), 
('Óleo de Soja 900ml', 6.50, 200), ('Macarrão Espaguete 500g', 4.80, 150), 
('Café Torrado e Moído 500g', 14.50, 60), ('Açúcar Refinado 1kg', 5.70, 100); 

INSERT INTO tbl_vendedor (nome, cpf, comissao, data_contratacao) 
VALUES ('Carlos Mendes', '12345678901', 5.00, '2022-02-10'), 
('Fernanda Souza', '23456789012', 6.50, '2023-09-18'), 
('Rafael Lima', '34567890123', 7.00, '2025-10-01'), 
('Patrícia Gomes', '45678901234', 4.75, '2020-12-21'); 

INSERT INTO tbl_fornecedor (cnpj, razao_social, telefone, cidade)
VALUES ('123456987000123', 'NutriMais Alimentos Ltda', '(62)3124-9987', 'Goiânia-GO'),
('22789654000187', 'techOne Informática EIRELI', '(62)4002-1789', 'Aparecida de Goiânia-GO'),
('33987456000109', 'BelaFlor Cosméticos ME', '(62)3551-2234', 'Rio Verde-GO'),
('45690873000144', 'AgroNova Sementes Ltda', '(62)3335-7810', 'Jussara-GO'),
('56908721000167', 'Bebidas Cerrado Distribuidora', '(62)3222-5577', 'Goiânia-GO'),
('67890512000111', 'Super Frio Refrigeração Comercial', '(62)3030-4455', 'Brasília-DF'),
('78906543000103', 'Sol Nascente Produtos Naturais', '(62)3289-3321', 'Itaberaí-GO'),
('89065432000125', 'Papel&Cia Embalagens Ltda', '(62)3545-7788', 'Anápolis-GO'),
('90123456000156', 'FarmaViva Produtos Farmacêuticos', '(62)3898-4422', 'Itapuranga-GO'),
('91234567000109', 'Conecta Energia Solar LTDA', '(62)3154-7780', 'Goiânia-GO');

INSERT INTO tbl_produto (descricao, preco_unitario, qtde_estoque)
VALUES ('Arroz Tipo 1 5 kg', 24.90, 80), ('Feijão Carioca 1kg', 9.90, 120),
('Óleo de Soja 900ml', 6.50, 200), ('Macarrão Espaguete 500g', 4.80, 150),
('Café Torrado e Moído 500g', 14.50, 60), ('Açúcar Refinado 1kg', 5.70, 100);