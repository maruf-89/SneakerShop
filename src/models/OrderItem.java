package models;

public class OrderItem {

    private int beställningId;
    private int skoId;
    private int antal;
    private double pris;

    public OrderItem() {
    }

    public OrderItem(int beställningId, int skoId, int antal, double pris) {
        this.beställningId = beställningId;
        this.skoId = skoId;
        this.antal = antal;
        this.pris = pris;
    }

    public int getBeställningId(){
        return beställningId;
    }
    public void setBeställningId(){
        this.beställningId = beställningId;
    }
    public int getSkoId(){
        return skoId;
    }
    public void setSkoId(int skoId){
        this.skoId = skoId;
    }
    public int getAntal(){
        return antal;
    }
    public void setAntal(int antal){
        this.antal = antal;
    }
    public double getPris(){
        return pris;
    }
    public void setPris(double pris){
        this.pris = pris;
    }
    @Override
    public String toString() {
        return String.format("Produkt %d x %d á %.2f kr = %.2f kr",
                skoId, antal, pris, (antal * pris));
    }



}
