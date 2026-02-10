USE SneakerShop;

-- FRÅGA 1: Kunder som köpt svarta Ecco sandaler storlek 38
SELECT DISTINCT CONCAT(k.Förnamn, ' ', k.Efternamn) AS Kundnamn
FROM Kund k
         JOIN Beställning b ON k.KundId = b.KundId
         JOIN Beställning_Sko bs ON b.BeställningId = bs.BeställningId
         JOIN Sko s ON bs.SkoId = s.SkoId
         JOIN Märke m ON s.MärkeId = m.MärkeId
         JOIN Sko_Kategori sk ON s.SkoId = sk.SkoId
         JOIN Kategori kat ON sk.KategoriId = kat.KategoriId
WHERE s.Färg = 'Svart'
  AND s.Storlek = 38
  AND m.Namn = 'Ecco'
  AND kat.Namn = 'Sandaler';

-- FRÅGA 2: Antal produkter per kategori
SELECT k.Namn AS Kategori, COUNT(DISTINCT sk.SkoId) AS AntalProdukter
FROM Kategori k
         LEFT JOIN Sko_Kategori sk ON k.KategoriId = sk.KategoriId
GROUP BY k.KategoriId, k.Namn
ORDER BY AntalProdukter DESC;

-- FRÅGA 3: Total summa per kund
SELECT k.Förnamn, k.Efternamn,
       COALESCE(SUM(bs.Antal * bs.Pris), 0) AS TotalSumma
FROM Kund k
         LEFT JOIN Beställning b ON k.KundId = b.KundId
         LEFT JOIN Beställning_Sko bs ON b.BeställningId = bs.BeställningId
GROUP BY k.KundId, k.Förnamn, k.Efternamn
ORDER BY TotalSumma DESC;

-- FRÅGA 4: Total per ort över 1000 kr
SELECT k.Ort, SUM(bs.Antal * bs.Pris) AS TotaltVärde
FROM Kund k
         JOIN Beställning b ON k.KundId = b.KundId
         JOIN Beställning_Sko bs ON b.BeställningId = bs.BeställningId
GROUP BY k.Ort
HAVING TotaltVärde > 1000
ORDER BY TotaltVärde DESC;

-- FRÅGA 5: Topp-5 mest sålda
SELECT s.Namn, s.Färg, s.Storlek, m.Namn AS Märke,
       SUM(bs.Antal) AS AntalSålda
FROM Sko s
         JOIN Märke m ON s.MärkeId = m.MärkeId
         JOIN Beställning_Sko bs ON s.SkoId = bs.SkoId
GROUP BY s.SkoId, s.Namn, s.Färg, s.Storlek, m.Namn
ORDER BY AntalSålda DESC
    LIMIT 5;

-- FRÅGA 6: Månad med störst försäljning
SELECT YEAR(b.Datum) AS År, MONTH(b.Datum) AS Månad,
    MONTHNAME(b.Datum) AS MånadsNamn,
    SUM(bs.Antal * bs.Pris) AS TotalFörsäljning
FROM Beställning b
    JOIN Beställning_Sko bs ON b.BeställningId = bs.BeställningId
GROUP BY YEAR(b.Datum), MONTH(b.Datum), MONTHNAME(b.Datum)
ORDER BY TotalFörsäljning DESC
    LIMIT 1;