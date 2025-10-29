CREATE TABLE Mesas(
    ID_Mesa INT PRIMARY KEY IDENTITY(1,1),
    Status_Mesa VARCHAR(20),
    Data_Reserva DATETIME
);

CREATE TABLE Cardapio(
    ID_Cardapio INT PRIMARY KEY IDENTITY(1,1),
    Nome_Prato VARCHAR(50),
    Preco DECIMAL(10,2)
);

CREATE TABLE Comandas(
    ID_Comanda INT PRIMARY KEY IDENTITY(1,1),
    Mesa INT NULL,
    Status_Comanda VARCHAR(15) NOT NULL, 
    Data_Abertura DATETIME,
    Data_Fechamento DATETIME,
    Valor_Total DECIMAL(10,2), 
    Forma_Pagamento VARCHAR(30),
    Tipo_Atendimento VARCHAR(10) NOT NULL,
    FOREIGN KEY (Mesa) REFERENCES Mesas(ID_Mesa)
);

CREATE TABLE Itens_Pedido(
    ID_ItemPedido INT PRIMARY KEY IDENTITY(1,1),
    ID_Comanda INT NOT NULL,
    ID_Cardapio INT NOT NULL, 
    Quantidade INT NOT NULL, 
    FOREIGN KEY (ID_Comanda) REFERENCES Comandas(ID_Comanda),
    FOREIGN KEY (ID_Cardapio) REFERENCES Cardapio(ID_Cardapio)
);

INSERT INTO Mesas (Status_Mesa, Data_Reserva) 
VALUES('Livre', NULL),
('Ocupada', NULL),
('Reservada', '2025-10-28T20:00:00'),
('Livre', NULL),
('Ocupada', NULL);

INSERT INTO Cardapio (Nome_Prato, Preco) 
VALUES('Bife à Parmegiana', 38.50),
('Salmão Grelhado', 55.00),   
('Lasanha Bolonhesa', 32.00), 
('Refrigerante Lata', 6.00),  
('Cerveja Artesanal', 18.00), 
('Picanha Grelhada', 95.00),  
('Água Mineral', 4.00);


INSERT INTO Comandas (Mesa, Status_Comanda, Data_Abertura, Data_Fechamento, Valor_Total, Forma_Pagamento, Tipo_Atendimento) 
VALUES(2, 'Aberta', '2025-10-28T10:15:00', NULL, 0.00, NULL, 'Mesa'),
(5, 'Fechada', '2025-10-27T19:30:00', '2025-10-27T21:05:00', 164.00, 'Dinheiro', 'Mesa'),
(NULL, 'Fechada', '2025-10-28T09:40:00', '2025-10-28T09:55:00', 102.00, 'Cartão', 'Balcao'),
(NULL, 'Aberta', '2025-10-28T10:40:00', NULL, 0.00, NULL, 'Delivery');


-- Comanda 1
INSERT INTO Itens_Pedido (ID_Comanda, ID_Cardapio, Quantidade) VALUES (1, 6, 1); 
INSERT INTO Itens_Pedido (ID_Comanda, ID_Cardapio, Quantidade) VALUES (1, 4, 2); 

-- Comanda 2
INSERT INTO Itens_Pedido (ID_Comanda, ID_Cardapio, Quantidade) VALUES (2, 2, 2);
INSERT INTO Itens_Pedido (ID_Comanda, ID_Cardapio, Quantidade) VALUES (2, 5, 3);

-- Comanda 3
INSERT INTO Itens_Pedido (ID_Comanda, ID_Cardapio, Quantidade) VALUES (3, 3, 3);
INSERT INTO Itens_Pedido (ID_Comanda, ID_Cardapio, Quantidade) VALUES (3, 4, 1);

-- Comanda 4
INSERT INTO Itens_Pedido (ID_Comanda, ID_Cardapio, Quantidade) VALUES (4, 6, 1);
INSERT INTO Itens_Pedido (ID_Comanda, ID_Cardapio, Quantidade) VALUES (4, 7, 1);

SELECT * FROM Mesas;
SELECT * FROM Cardapio;
SELECT * FROM Itens_Pedido;
SELECT * FROM Comandas;

-- Itens pedidos em cada comanda
SELECT
    c.ID_Comanda AS 'ID da Comanda',
    ca.Nome_Prato AS 'Nome do Prato',
    ca.Preco AS 'Preco',
    ip.Quantidade AS 'Quantidade',
    (ip.Quantidade * ca.Preco) AS Total
FROM 
    Comandas AS c
INNER JOIN 
    Itens_Pedido AS ip ON C.ID_Comanda = ip.ID_Comanda 
INNER JOIN 
    Cardapio AS ca ON ip.ID_Cardapio = ca.ID_Cardapio;

-- Status das mesas desse estabelecimento
SELECT
    m.ID_Mesa AS 'ID da Mesa',
    m.Status_Mesa AS 'Status da Mesa',
    CASE 
        WHEN c.ID_Comanda IS NOT NULL AND c.Status_Comanda = 'Aberta' THEN 'SIM'
        ELSE 'NÃO'
    END AS 'Comanda Ativa',
    c.ID_Comanda AS 'ID da Comanda'
FROM 
    Mesas AS m
LEFT JOIN
    Comandas AS c ON c.Mesa = m.ID_Mesa;

-- Itens pedidos apenas nas mesas
SELECT
   ca.Nome_Prato AS 'Nome do Prato',
   (ca.Preco * ip.quantidade) AS 'Valor Total',
   ip.Quantidade,
   c.Tipo_Atendimento AS 'Tipo de Atendimento'
FROM 
    Cardapio AS ca 
LEFT JOIN
    Itens_Pedido AS ip ON ca.ID_Cardapio = ip.ID_Cardapio
LEFT JOIN
    Comandas AS c ON c.ID_Comanda = ip.ID_Comanda
WHERE
    c.Tipo_Atendimento = 'Mesa';
