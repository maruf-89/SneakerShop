package models;

public class Customer {
    private int kundId;
    private String förnamn;
    private String efternamn;
    private String adress;
    private String postnummer;
    private String ort;
    private String lösenord;

    public Customer() {
    }

    public Customer(int kundId, String förnamn, String efternamn, String adress,
                    String postnummer, String ort, String lösenord) {
        this.kundId = kundId;
        this.förnamn = förnamn;
        this.efternamn = efternamn;
        this.adress = adress;
        this.postnummer = postnummer;
        this.ort = ort;
        this.lösenord = lösenord;
    }

    public int getKundId() {
        return kundId;
    }

    public void setKundId(int kundId) {
        this.kundId = kundId;
    }

    public String getFörnamn() {
        return förnamn;
    }

    public void setFörnamn(String förnamn) {
        this.förnamn = förnamn;
    }

    public String getEfternamn() {
        return efternamn;
    }

    public void setEfternamn(String efternamn) {
        this.efternamn = efternamn;
    }

    public String getAdress() {
        return adress;
    }

    public void setAdress(String adress) {
        this.adress = adress;
    }

    public String getPostnummer() {
        return postnummer;
    }

    public void setPostnummer(String postnummer) {
        this.postnummer = postnummer;
    }

    public String getOrt() {
        return ort;
    }

    public void setOrt(String ort) {
        this.ort = ort;
    }

    public String getLösenord() {
        return lösenord;
    }

    public void setLösenord(String lösenord) {
        this.lösenord = lösenord;
    }

    @Override
    public String toString() {
        return förnamn + " " + efternamn + " (" + ort + ")";
    }
}