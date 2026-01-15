CREATE DATABASE db_projeto_venda;

use db_projeto_venda;

CREATE TABLE tbl_cliente (
    id                 INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
    nome               VARCHAR(100) NOT NULL,
    tipo               ENUM('PF', 'PJ') NOT NULL
);

CREATE TABLE tbl_pessoa_pf (
    id_cliente         INT NOT NULL,
    cpf                VARCHAR(11) NOT NULL,
    data_nascimento    DATE NOT NULL,
    
    CONSTRAINT PK_Pessoa_PF 
    PRIMARY KEY (id_cliente),
    CONSTRAINT FK_Pessoa_PF_Cliente 
    FOREIGN KEY (id_cliente)
	  REFERENCES tbl_cliente (id)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
        
    CONSTRAINT UQ_Pessoa_PF_CPF 
    UNIQUE (cpf),
    CONSTRAINT CK_Pessoa_PF_FormatoCPF 
    CHECK (cpf REGEXP '^[0-9]{11}$')
);
 
CREATE TABLE tbl_pessoa_pj (
    id_cliente         INT NOT NULL,
    cnpj               VARCHAR(14) NOT NULL,
    razao_social       VARCHAR(100) NOT NULL,
    
    CONSTRAINT PK_Pessoa_PJ 
    PRIMARY KEY (id_cliente),
    CONSTRAINT FK_Pessoa_PJ_Cliente 
    FOREIGN KEY (id_cliente)
	  
    REFERENCES tbl_cliente (id)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
        
    CONSTRAINT UQ_Pessoa_PJ_CNPJ 
    UNIQUE (cnpj),
    CONSTRAINT CK_Pessoa_PJ_FormatoCNPJ 
    CHECK (cnpj REGEXP '^[0-9]{14}$')
);
    
CREATE TABLE tbl_endereco (
    id                 INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
    bairro             VARCHAR(45) NOT NULL,
    complemento        VARCHAR(100) NOT NULL,
    numero             VARCHAR(45) NOT NULL,
    cidade             VARCHAR(65) NOT NULL,
    uf                 ENUM('AC', 'AL', 'AP', 'AM', 'BA', 'CE', 'DF', 'ES', 'GO', 'MA', 'MT', 'MS', 'MG', 'PA', 
                            'PB', 'PR', 'PE', 'PI', 'RJ', 'RN', 'RS', 'RO', 'RR', 'SC', 'SP', 'TO', 'SE') NOT NULL,
    cep                VARCHAR(8) NOT NULL,
    id_cliente         INT NOT NULL,
    
    CONSTRAINT FK_Endereco_Cliente 
    FOREIGN KEY (id_cliente)
    REFERENCES tbl_cliente (id)
    ON DELETE CASCADE 
    ON UPDATE CASCADE,
    CONSTRAINT CK_Endereco_FormatoCEP 
    CHECK (cep REGEXP '^\d{5}-?\d{3}$')
);

CREATE TABLE tbl_telefone (
    id                 INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
    numero             VARCHAR(20) NOT NULL,
    id_cliente         INT NOT NULL,
    
    CONSTRAINT FK_Telefone_Cliente 
    FOREIGN KEY (id_cliente)
    REFERENCES tbl_cliente (id)
    ON DELETE CASCADE 
    ON UPDATE CASCADE,
    
    CONSTRAINT UN_Telefone_Cliente 
    UNIQUE (id_cliente, numero),
    CONSTRAINT CK_Telefone_FormatoNumero 
    CHECK (numero REGEXP '^\([0-9]{2}\) [0-9]{5}-[0-9]{4}$')
);

CREATE TABLE tbl_email (
    id                 INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
    email              VARCHAR(255) NOT NULL,
    id_cliente         INT NOT NULL,
    
    CONSTRAINT FK_Email_Cliente 
    FOREIGN KEY (id_cliente)
    REFERENCES tbl_cliente (id)
    ON DELETE CASCADE 
    ON UPDATE CASCADE,
    
    CONSTRAINT UN_Email_Cliente 
    UNIQUE (id_cliente, email),
    CONSTRAINT CK_Email_FormatoEmail 
    CHECK (email REGEXP '^[A-Za-z0-9_%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,6}$')
);
    
CREATE TABLE tbl_produto (
    id                 INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
    descricao          VARCHAR(100),
    preco_unitario     DECIMAL(10 , 2 ) NOT NULL,
    qtde_estoque       INT NOT NULL,
    
    CONSTRAINT CK_Produto_PrecoValido 
    CHECK (preco_unitario > 0),
    CONSTRAINT CK_Produto_QtdeValida 
    CHECK (qtde_estoque >= 0)
);
    
CREATE TABLE tbl_fornecedor (
    id                 INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
    cnpj               VARCHAR(14) NOT NULL,
    razao_social       VARCHAR(100) NOT NULL,
    telefone           VARCHAR(20) NOT NULL,
    cidade             VARCHAR(60) NOT NULL,
    
    CONSTRAINT CK_FornecedorCNPJ 
    CHECK (cnpj REGEXP '^[0-9]{14}$'),
    CONSTRAINT UQ_Vendedor_CNPJ 
    UNIQUE (cnpj),
    CONSTRAINT CK_FornecedorContato 
    CHECK (telefone REGEXP '^\([0-9]{2}\) [0-9]{5}-[0-9]{4}$')
);
    
CREATE TABLE tbl_fornecer_produto (
    id_fornecedor      INT NOT NULL,
    id_produto         INT NOT NULL,
    preco_custo        DECIMAL(10 , 2 ) NOT NULL,
    prazo_entrega_dias INT NOT NULL,
    
    CONSTRAINT PK_Fornecer_Produto 
    PRIMARY KEY (id_fornecedor , id_produto),
    CONSTRAINT FK_Fornecedor_Fornecer_Produto 
    FOREIGN KEY (id_fornecedor)
    REFERENCES tbl_fornecedor (id)
    ON DELETE RESTRICT 
    ON UPDATE CASCADE,
    
    CONSTRAINT FK_Produto_Fornecer_Produto 
    FOREIGN KEY (id_produto)
    REFERENCES tbl_produto (id)
    ON DELETE RESTRICT 
    ON UPDATE CASCADE,
    
    CONSTRAINT CK_Produto_ValorPositivo 
    CHECK (preco_custo > 0),
    CONSTRAINT CK_Produto_PrazoValido 
    CHECK (prazo_entrega_dias >= 0)
);


CREATE TABLE tbl_vendedor (
    id                 INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
    nome               VARCHAR(100) NOT NULL,
    cpf                VARCHAR(11) NOT NULL,
    comissao           DECIMAL(5 , 2 ) NOT NULL DEFAULT 5.00,
    data_contratacao   DATE NOT NULL,
    
    CONSTRAINT CK_Vendedor_FormatoCPF 
    CHECK (cpf REGEXP '^[0-9]{11}$'),
    CONSTRAINT UQ_Vendedor_CPF 
    UNIQUE (cpf),
    CONSTRAINT CK_VendedorComissao 
    CHECK (comissao >= 0 AND comissao <= 100)
);

CREATE TABLE tbl_venda (
    id                 INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
    id_vendedor        INT NULL,
    id_cliente         INT NOT NULL,
    data_venda         DATE NOT NULL,
    
    CONSTRAINT FK_Vendedor_Venda 
    FOREIGN KEY (id_vendedor)
	  REFERENCES tbl_vendedor (id)
  	ON DELETE SET NULL 
    ON UPDATE CASCADE,
    
    CONSTRAINT FK_Cliente_Venda 
    FOREIGN KEY (id_cliente)
	  REFERENCES tbl_cliente (id)
	  ON DELETE RESTRICT 
    ON UPDATE CASCADE
);
   
CREATE TABLE tbl_item_venda (
    id_produto         INT NOT NULL,
    id_venda           INT NOT NULL,
    preco_unitario     DECIMAL(10 , 2 ) NOT NULL,
    qtde_vendida       INT NOT NULL,
    
    CONSTRAINT PK_Item_Venda 
    PRIMARY KEY (id_produto , id_venda),
    CONSTRAINT FK_Produto_Item_Venda 
    FOREIGN KEY (id_produto)
	  REFERENCES tbl_produto (id)
	  ON DELETE CASCADE 
    ON UPDATE CASCADE,
    
    CONSTRAINT FK_Venda_Item_Venda 
    FOREIGN KEY (id_venda)
	  REFERENCES tbl_venda (id)
	  ON DELETE CASCADE 
    ON UPDATE CASCADE,
    
    CONSTRAINT CK_ItemVenda_PrecoValido 
    CHECK (preco_unitario > 0),
    CONSTRAINT CK_ItemVenda_QtdePositiva 
    CHECK (qtde_vendida > 0)
);
   
CREATE TABLE tbl_pagamento (
    id_venda           INT NOT NULL,
    numero_parcela     TINYINT UNSIGNED NOT NULL,
    data_vencimento    DATE NOT NULL,
    data_pagamento     DATE NULL,
    status_pagamento   ENUM('PENDENTE', 'PAGO', 'VENCIDO', 'CANCELADO') NOT NULL DEFAULT 'PENDENTE',
    forma_pagamento    ENUM('À VISTA', 'PARCELADO', 'PIX', 'BOLETO', 'CHEQUE', 'DINHEIRO') NOT NULL,
    valor              DECIMAL(10 , 2 ) NOT NULL,
    
    PRIMARY KEY (id_venda, numero_parcela),
    CONSTRAINT FK_Pagamento_Venda 
    FOREIGN KEY (id_venda)
	  REFERENCES tbl_venda (id)
	  ON DELETE RESTRICT 
    ON UPDATE CASCADE,
    CONSTRAINT CK_Pagamento_ValorPositivo 
    CHECK (valor > 0)
);

-- 💰 Pagamento à vista em dinheiro
INSERT INTO tbl_pagamento (id_venda, numero_parcela, data_vencimento, data_pagamento, status_pagamento, forma_pagamento, valor)
SELECT v.id, 1, '2025-10-25', NULL, 'PENDENTE', 'DINHEIRO',
       ROUND(SUM(iv.preco_unitario * iv.qtde_vendida), 2)
FROM tbl_venda v
JOIN tbl_item_venda iv ON iv.id_venda = v.id
WHERE v.data_venda = '2025-10-20'
GROUP BY v.id;

-- 💳 Pagamento à vista no PIX
INSERT INTO tbl_pagamento (id_venda, numero_parcela, data_vencimento, data_pagamento, status_pagamento, forma_pagamento, valor)
SELECT v.id, 1, '2025-10-26', NULL, 'PENDENTE', 'PIX',
       ROUND(SUM(iv.preco_unitario * iv.qtde_vendida), 2)
FROM tbl_venda v
JOIN tbl_item_venda iv ON iv.id_venda = v.id
WHERE v.data_venda = '2025-10-25'
GROUP BY v.id;

-- 🧾 Pagamento parcelado (3x - exemplo padrão)
CREATE TEMPORARY TABLE tmp_tot AS
SELECT v.id AS id_venda,
       ROUND(SUM(iv.preco_unitario * iv.qtde_vendida), 2) AS total
FROM tbl_venda v
JOIN tbl_item_venda iv ON iv.id_venda = v.id
WHERE v.data_venda = '2025-12-10'
GROUP BY v.id;

INSERT INTO tbl_pagamento (id_venda, numero_parcela, data_vencimento, status_pagamento, forma_pagamento, valor)
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
