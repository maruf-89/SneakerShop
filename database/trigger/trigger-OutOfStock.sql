-- TRIGGER: OutOfStock Alert
-- Känner av när en produkt tar slut i lager
-- Loggar händelsen i OutOfStock-tabellen
USE SneakerShop;

DELIMITER //

DROP TRIGGER IF EXISTS trg_check_out_of_stock//

CREATE TRIGGER trg_check_out_of_stock
 AFTER UPDATE ON Sko
 FOR EACH ROW
BEGIN
-- Kontrollera om produkten gått från >0 till 0 i lager
 IF OLD.LagerAntal > 0 AND NEW.LagerAntal = 0 THEN
-- Logga att produkten tagit slut
 INSERT INTO OutOfStock (SkoId, Tidpunkt)
 VALUES (NEW.SkoId, NOW());
END IF;
END//

DELIMITER ;