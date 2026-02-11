DROP DATABASE IF EXISTS sneakershop;
CREATE DATABASE sneakerShop;
USE sneakerShop;

-- Tabell: Märke
CREATE TABLE Märke (
 MärkeId INT AUTO_INCREMENT PRIMARY KEY,
 Namn VARCHAR(50) NOT NULL UNIQUE
) ENGINE=InnoDB;

-- Tabell: Sko
CREATE TABLE Sko (
 SkoId INT AUTO_INCREMENT PRIMARY KEY,
 Namn VARCHAR(100) NOT NULL,
 Färg VARCHAR(30) NOT NULL,
 Storlek INT NOT NULL,
 Pris DECIMAL(10,2) NOT NULL,
 LagerAntal INT NOT NULL DEFAULT 0,
 MärkeId INT NOT NULL,
 FOREIGN KEY (MärkeId) REFERENCES Märke(MärkeId)
 ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB;

-- Index för snabbare sökning
CREATE INDEX idx_sko_namn ON Sko(Namn);
CREATE INDEX idx_sko_farg ON Sko(Färg);
CREATE INDEX idx_sko_storlek ON Sko(Storlek);

-- Tabell: Kategori
CREATE TABLE Kategori (
 KategoriId INT AUTO_INCREMENT PRIMARY KEY,
 Namn VARCHAR(50) NOT NULL UNIQUE
) ENGINE=InnoDB;

-- Tabell: Sko_Kategori (kopplingstabell)
CREATE TABLE Sko_Kategori (
 SkoId INT NOT NULL,
 KategoriId INT NOT NULL,
 PRIMARY KEY (SkoId, KategoriId),
 FOREIGN KEY (SkoId) REFERENCES Sko(SkoId)
 ON DELETE CASCADE ON UPDATE CASCADE,
 FOREIGN KEY (KategoriId) REFERENCES Kategori(KategoriId)
 ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

-- Tabell: Kund
CREATE TABLE Kund (
 KundId INT AUTO_INCREMENT PRIMARY KEY,
 Förnamn VARCHAR(50) NOT NULL,
 Efternamn VARCHAR(50) NOT NULL,
 Adress VARCHAR(100) NOT NULL,
 Postnummer VARCHAR(10) NOT NULL,
 Ort VARCHAR(50) NOT NULL,
 Lösenord VARCHAR(100) NOT NULL
) ENGINE=InnoDB;

-- Tabell: Beställning
CREATE TABLE Beställning (
 BeställningId INT AUTO_INCREMENT PRIMARY KEY,
 Datum DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
 KundId INT NOT NULL,
 Status ENUM('AKTIV', 'BETALD') NOT NULL DEFAULT 'AKTIV',
 FOREIGN KEY (KundId) REFERENCES Kund(KundId)
 ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB;

CREATE INDEX idx_bestallning_status ON Beställning(Status);

-- Tabell: Beställning_Sko (kopplingstabell)
CREATE TABLE Beställning_Sko (
 BeställningId INT NOT NULL,
 SkoId INT NOT NULL,
 Antal INT NOT NULL DEFAULT 1,
 Pris DECIMAL(10,2) NOT NULL,
 PRIMARY KEY (BeställningId, SkoId),
 FOREIGN KEY (BeställningId) REFERENCES Beställning(BeställningId)
 ON DELETE CASCADE ON UPDATE CASCADE,
 FOREIGN KEY (SkoId) REFERENCES Sko(SkoId)
 ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB;

-- Tabell: OutOfStock (för trigger)
CREATE TABLE OutOfStock (
 Id INT AUTO_INCREMENT PRIMARY KEY,
 SkoId INT NOT NULL,
 Tidpunkt DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
 FOREIGN KEY (SkoId) REFERENCES Sko(SkoId)
 ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

-- Lägg till märken
INSERT INTO Märke (Namn) VALUES
 ('Nike'), ('Adidas'), ('Ecco'), ('Puma'), ('Reebok');

-- Lägg till kategorier
INSERT INTO Kategori (Namn) VALUES
 ('Sportskor'), ('Löparskor'), ('Damskor'), ('Herrskor'),
 ('Promenadskor'), ('Sandaler'), ('Veganskor');

-- Lägg till skor
INSERT INTO Sko (Namn, Färg, Storlek, Pris, LagerAntal, MärkeId) VALUES
 ('Ecco Comfort Sandal', 'Svart', 38, 899.00, 5, 3),
 ('Ecco Comfort Sandal', 'Svart', 40, 899.00, 3, 3),
 ('Nike Air Max', 'Vit', 42, 1299.00, 10, 1),
 ('Nike Air Max', 'Svart', 42, 1299.00, 8, 1),
 ('Adidas Ultra Boost', 'Blå', 41, 1599.00, 12, 2),
 ('Puma Runner', 'Röd', 39, 699.00, 2, 4),
 ('Reebok Classic', 'Vit', 43, 799.00, 15, 5),
 ('Nike Vegan Pro', 'Grön', 40, 1099.00, 7, 1),
 ('Ecco Walking Shoe', 'Brun', 41, 1199.00, 6, 3),
 ('Adidas Promenad', 'Grå', 38, 899.00, 4, 2);

-- Koppla skor till kategorier
INSERT INTO Sko_Kategori (SkoId, KategoriId) VALUES
 (1, 6), (1, 3), (1, 5),
 (2, 6), (2, 5),
 (3, 1), (3, 2), (3, 4),
 (4, 1), (4, 4),
 (5, 1), (5, 2),
 (6, 1), (6, 3),
 (7, 5), (7, 4),
 (8, 1), (8, 7),
 (9, 5), (9, 4),
 (10, 5), (10, 3);

-- Lägg till kunder
INSERT INTO Kund (Förnamn, Efternamn, Adress, Postnummer, Ort, Lösenord) VALUES
 ('Anna', 'Andersson', 'Storgatan 12', '11122', 'Stockholm', 'password123'),
 ('Erik', 'Eriksson', 'Lillgatan 5', '41103', 'Göteborg', 'hejhej'),
 ('Maria', 'Svensson', 'Kungsgatan 8', '21143', 'Malmö', 'maria2024'),
 ('Johan', 'Johansson', 'Parkvägen 3', '11122', 'Stockholm', 'johan123'),
 ('Lisa', 'Karlsson', 'Strandvägen 15', '75320', 'Uppsala', 'lisa456');

-- Lägg till beställningar
INSERT INTO Beställning (Datum, KundId, Status) VALUES
 ('2025-01-15 10:30:00', 1, 'BETALD'),
 ('2025-01-20 14:22:00', 4, 'BETALD'),
 ('2025-02-05 09:15:00', 2, 'BETALD'),
 ('2025-02-08 16:45:00', 3, 'BETALD'),
 ('2024-12-10 11:00:00', 5, 'BETALD'),
 ('2024-12-20 13:30:00', 1, 'BETALD');

-- Lägg till produkter i beställningar
INSERT INTO Beställning_Sko (BeställningId, SkoId, Antal, Pris) VALUES
 (1, 1, 1, 899.00),
 (1, 3, 2, 1299.00),
 (2, 1, 2, 899.00),
 (2, 5, 1, 1599.00),
 (3, 4, 1, 1299.00),
 (3, 7, 1, 799.00),
 (4, 6, 1, 699.00),
 (5, 8, 2, 1099.00),
 (6, 9, 1, 1199.00),
 (6, 10, 1, 899.00);

SELECT 'Databas skapad!' AS Status;