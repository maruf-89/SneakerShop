USE SneakerShop;

DELIMITER //

DROP PROCEDURE IF EXISTS AddToCart//

CREATE PROCEDURE AddToCart(
 IN p_KundId INT,
 IN p_BeställningId INT,
 IN p_SkoId INT
)
 proc_label: BEGIN
 DECLARE v_BeställningId INT;
 DECLARE v_Pris DECIMAL(10,2);
 DECLARE v_Lager INT;

 DECLARE EXIT HANDLER FOR SQLEXCEPTION
BEGIN
ROLLBACK;
SELECT 'ERROR' AS Status, 'Tekniskt fel.' AS Meddelande;
END;

START TRANSACTION;

-- Hämta pris och lager
SELECT Pris, LagerAntal INTO v_Pris, v_Lager
FROM Sko WHERE SkoId = p_SkoId;

-- Kolla om produkt finns i lager
IF v_Lager <= 0 THEN
 ROLLBACK;
SELECT 'ERROR' AS Status, 'Slut i lager.' AS Meddelande;
LEAVE proc_label;
END IF;

-- Hitta eller skapa aktiv beställning
 IF p_BeställningId IS NULL THEN
SELECT BeställningId INTO v_BeställningId
FROM Beställning
WHERE KundId = p_KundId AND Status = 'AKTIV'
 LIMIT 1;

IF v_BeställningId IS NULL THEN
 INSERT INTO Beställning (KundId, Status)
 VALUES (p_KundId, 'AKTIV');
 SET v_BeställningId = LAST_INSERT_ID();
END IF;
ELSE
 SET v_BeställningId = p_BeställningId;
END IF;

-- Lägg till produkt (eller öka antal)
INSERT INTO Beställning_Sko (BeställningId, SkoId, Antal, Pris)
VALUES (v_BeställningId, p_SkoId, 1, v_Pris)
 ON DUPLICATE KEY UPDATE Antal = Antal + 1;

-- Minska lager
UPDATE Sko SET LagerAntal = LagerAntal - 1
WHERE SkoId = p_SkoId;

COMMIT;

SELECT 'SUCCESS' AS Status, 'Tillagd i kundvagnen!' AS Meddelande;
END//

DELIMITER ;