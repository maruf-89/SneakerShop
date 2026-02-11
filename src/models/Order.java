package models;

import java.time.LocalDateTime;

public class Order {
    private int beställningId;
    private LocalDateTime datum;
    private int kundId;
    private String status;


    public Order() {
    }

    public Order(int beställningId, LocalDateTime datum, int kundId, String status) {
        this.beställningId = beställningId;
        this.datum = datum;
        this.kundId = kundId;
        this.status = status;
    }

    public int getBeställningId() {
        return beställningId;
    }

    public void setBeställningId(int beställningId){
        this.beställningId = beställningId;
    }

    public LocalDateTime getDatum() {
        return datum;
    }
    public void setDatum(LocalDateTime datum) {
        this.datum = datum;
    }
    public int getKundId() {
        return kundId;
    }
    public void setKundId(int kundId) {
        this.kundId = kundId;
    }
    public String getStatus() {
        return status;
    }
    public void setStatus(String status) {
        this.status = status;
    }
    @Override
    public String toString() {
        return String.format("Beställning #%d - %s - Status: %s",
                beställningId, datum, status);
    }


}
