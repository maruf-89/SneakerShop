USE SneakerShop;
SET SQL_SAFE_UPDATES = 0;

-- Rensa aktiva beställningar
DELETE FROM Beställning_Sko WHERE BeställningId > 0;
DELETE FROM Beställning WHERE Status = 'AKTIV';
DELETE FROM OutOfStock WHERE Id > 0;

-- Återställ lager
UPDATE Sko SET LagerAntal = 5  WHERE SkoId = 1;
UPDATE Sko SET LagerAntal = 3  WHERE SkoId = 2;
UPDATE Sko SET LagerAntal = 10 WHERE SkoId = 3;
UPDATE Sko SET LagerAntal = 8  WHERE SkoId = 4;
UPDATE Sko SET LagerAntal = 12 WHERE SkoId = 5;
UPDATE Sko SET LagerAntal = 2  WHERE SkoId = 6;
UPDATE Sko SET LagerAntal = 15 WHERE SkoId = 7;
UPDATE Sko SET LagerAntal = 7  WHERE SkoId = 8;
UPDATE Sko SET LagerAntal = 6  WHERE SkoId = 9;
UPDATE Sko SET LagerAntal = 4  WHERE SkoId = 10;

SET SQL_SAFE_UPDATES = 1;

SELECT 'Återställd!' AS Status;