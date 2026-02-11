package models;

public class Product {

    private int skoId;
    private String namn;
    private String färg;
    private int storlek;
    private double pris;
    private int lagerAntal;
    private String märkeNamn;

    public Product(){
    }

    public Product(int skoId, String namn, String färg, int storlek,
                   double pris, int lagerAntal, String märkeNamn) {
        this.skoId = skoId;
        this.namn = namn;
        this.färg = färg;
        this.storlek = storlek;
        this.pris = pris;
        this.lagerAntal = lagerAntal;
        this.märkeNamn = märkeNamn;
    }

    public int getSkoId() {
        return skoId;
    }

    public void setSkoId(int skoId) {
        this.skoId = skoId;
    }

    public String getNamn() {
        return namn;
    }

    public void setNamn(String namn) {
        this.namn = namn;
    }

    public String getFärg() {
        return färg;
    }

    public void setFärg(String färg) {
        this.färg = färg;
    }

    public int getStorlek() {
        return storlek;
    }

    public void setStorlek(int storlek) {
        this.storlek = storlek;
    }

    public double getPris() {
        return pris;
    }

    public void setPris(double pris) {
        this.pris = pris;
    }

    public int getLagerAntal() {
        return lagerAntal;
    }

    public void setLagerAntal(int lagerAntal) {
        this.lagerAntal = lagerAntal;
    }

    public String getMärkeNamn() {
        return märkeNamn;
    }

    public void setMärkeNamn(String märkeNamn) {
        this.märkeNamn = märkeNamn;
    }
    @Override
    public String toString() {
        return String.format("%s - %s - Storlek %d (%s) - %.2f kr - Lager: %d",
                namn, färg, storlek, märkeNamn, pris, lagerAntal);
    }
}
