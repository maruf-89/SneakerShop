import databaseconnection.DatabaseConnection;
import models.Customer;
import models.Product;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.Scanner;

public class Main {
    private static Scanner scanner = new Scanner(System.in);
    private static Customer inloggadKund = null;

    public static void main(String[] args) {
        System.out.println("Välkommen till SneakerShop Online");

        try {
            DatabaseConnection.getConnection();
            System.out.println("✓ Ansluten till databasen\n");
        } catch (SQLException e) {
            System.err.println("✗ Kunde inte ansluta till databasen.");
            return;
        }

        boolean running = true;
        while (running) {
            if (inloggadKund == null) {
                inloggning();
            } else {
                running = visaMeny();
            }
        }

        DatabaseConnection.closeConnection();
        scanner.close();
        System.out.println("\nTack för besöket!");
    }

    private static void inloggning() {
        System.out.println("\n--- INLOGGNING ---");
        System.out.print("Användarnamn: ");
        String användarnamn = scanner.nextLine().trim();
        System.out.print("Lösenord: ");
        String lösenord = scanner.nextLine().trim();

        try {
            inloggadKund = valideraInloggning(användarnamn, lösenord);
            if (inloggadKund != null) {
                System.out.println("\n✓ Välkommen " + inloggadKund.getFörnamn() + "!");
            } else {
                System.out.println("\n✗ Fel användarnamn eller lösenord.");
            }
        } catch (SQLException e) {
            System.err.println("\n✗ Databasfel: " + e.getMessage());
        }
    }

    private static Customer valideraInloggning(String användarnamn, String lösenord)
            throws SQLException {
        String sql = "SELECT * FROM Kund WHERE Förnamn = ? AND Lösenord = ?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, användarnamn);
            stmt.setString(2, lösenord);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                return new Customer(
                        rs.getInt("KundId"),
                        rs.getString("Förnamn"),
                        rs.getString("Efternamn"),
                        rs.getString("Adress"),
                        rs.getString("Postnummer"),
                        rs.getString("Ort"),
                        rs.getString("Lösenord")
                );
            }
        }
        return null;
    }

    private static boolean visaMeny() {
        System.out.println("\n--- MENY ---");
        System.out.println("1. Visa produkter");
        System.out.println("2. Lägg till i kundvagn");
        System.out.println("3. Visa kundvagn");
        System.out.println("4. Logga ut");
        System.out.println("5. Avsluta");
        System.out.print("\nVälj (1-5): ");

        String val = scanner.nextLine().trim();

        switch (val) {
            case "1": visaProdukter(); break;
            case "2": läggTillProdukt(); break;
            case "3": visaKundvagn(); break;
            case "4":
                inloggadKund = null;
                System.out.println("\n✓ Utloggad.");
                break;
            case "5": return false;
            default: System.out.println("\n✗ Ogiltigt val.");
        }
        return true;
    }

    private static void visaProdukter() {
        System.out.println("\n--- PRODUKTER ---\n");

        try {
            List<Product> produkter = hämtaProdukter();

            if (produkter.isEmpty()) {
                System.out.println("Inga produkter i lager.");
                return;
            }

            for (int i = 0; i < produkter.size(); i++) {
                System.out.printf("%d. %s\n", (i + 1), produkter.get(i));
            }
        } catch (SQLException e) {
            System.err.println("\n✗ Kunde inte hämta produkter: " + e.getMessage());
        }
    }

    private static List<Product> hämtaProdukter() throws SQLException {
        List<Product> produkter = new ArrayList<>();

        String sql = "SELECT s.SkoId, s.Namn, s.Färg, s.Storlek, s.Pris, " +
                "s.LagerAntal, m.Namn AS MärkeNamn " +
                "FROM Sko s " +
                "JOIN Märke m ON s.MärkeId = m.MärkeId " +
                "WHERE s.LagerAntal >= 0 " +
                "ORDER BY s.Namn";

        try (Connection conn = DatabaseConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {

            while (rs.next()) {
                produkter.add(new Product(
                        rs.getInt("SkoId"),
                        rs.getString("Namn"),
                        rs.getString("Färg"),
                        rs.getInt("Storlek"),
                        rs.getDouble("Pris"),
                        rs.getInt("LagerAntal"),
                        rs.getString("MärkeNamn")
                ));
            }
        }
        return produkter;
    }

    private static void läggTillProdukt() {
        System.out.println("\n--- LÄGG TILL I KUNDVAGN ---\n");

        try {
            List<Product> produkter = hämtaProdukter();

            if (produkter.isEmpty()) {
                System.out.println("Inga produkter i lager.");
                return;
            }

            for (int i = 0; i < produkter.size(); i++) {
                System.out.printf("%d. %s\n", (i + 1), produkter.get(i));
            }

            System.out.print("\nVälj produkt: ");
            String input = scanner.nextLine().trim();

            try {
                int val = Integer.parseInt(input);

                if (val < 1 || val > produkter.size()) {
                    System.out.println("\n✗ Ogiltigt val.");
                    return;
                }

                Product produkt = produkter.get(val - 1);
                läggTillIKundvagn(inloggadKund.getKundId(), produkt.getSkoId());

            } catch (NumberFormatException e) {
                System.out.println("\n✗ Ange ett nummer.");
            }
        } catch (SQLException e) {
            System.err.println("\n✗ Databasfel: " + e.getMessage());
        }
    }

    private static void läggTillIKundvagn(int kundId, int skoId) {
        String sql = "{CALL AddToCart(?, ?, ?)}";

        try (Connection conn = DatabaseConnection.getConnection();
             CallableStatement stmt = conn.prepareCall(sql)) {

            stmt.setInt(1, kundId);
            stmt.setNull(2, Types.INTEGER);
            stmt.setInt(3, skoId);

            stmt.execute();
            ResultSet rs = stmt.getResultSet();

            if (rs != null && rs.next()) {
                String status = rs.getString("Status");
                String meddelande = rs.getString("Meddelande");

                if ("SUCCESS".equals(status)) {
                    System.out.println("\n✓ " + meddelande);
                } else {
                    System.out.println("\n✗ " + meddelande);
                }
            }
        } catch (SQLException e) {
            System.err.println("\n✗ Databasfel: " + e.getMessage());
        }
    }

    private static void visaKundvagn() {
        System.out.println("\n--- DIN KUNDVAGN ---\n");

        try {
            String sql = "SELECT s.Namn, s.Färg, s.Storlek, m.Namn AS Märke, " +
                    "bs.Antal, bs.Pris, (bs.Antal * bs.Pris) AS Totalt " +
                    "FROM Beställning b " +
                    "JOIN Beställning_Sko bs ON b.BeställningId = bs.BeställningId " +
                    "JOIN Sko s ON bs.SkoId = s.SkoId " +
                    "JOIN Märke m ON s.MärkeId = m.MärkeId " +
                    "WHERE b.KundId = ? AND b.Status = 'AKTIV'";

            try (Connection conn = DatabaseConnection.getConnection();
                 PreparedStatement stmt = conn.prepareStatement(sql)) {

                stmt.setInt(1, inloggadKund.getKundId());
                ResultSet rs = stmt.executeQuery();

                double total = 0;
                boolean harProdukter = false;

                while (rs.next()) {
                    harProdukter = true;
                    System.out.printf("• %s - %s - Storlek %d (%s)\n",
                            rs.getString("Namn"),
                            rs.getString("Färg"),
                            rs.getInt("Storlek"),
                            rs.getString("Märke")
                    );
                    System.out.printf("  Antal: %d × %.2f kr = %.2f kr\n\n",
                            rs.getInt("Antal"),
                            rs.getDouble("Pris"),
                            rs.getDouble("Totalt")
                    );
                    total += rs.getDouble("Totalt");
                }

                if (!harProdukter) {
                    System.out.println("Kundvagnen är tom.");
                } else {
                    System.out.println("TOTALT: " + total + " kr");
                }
            }
        } catch (SQLException e) {
            System.err.println("\n✗ Kunde inte hämta kundvagn: " + e.getMessage());
        }
    }
}