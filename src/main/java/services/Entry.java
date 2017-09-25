package services;

import java.io.Serializable;
import java.time.LocalDate;

/**
 * Created by KimRostgard on 25.09.2017.
 */
public class Entry implements Serializable {
    private LocalDate date;
    private int room_nr;
    private int slot_nr;

    public Entry(){}

    public Entry(LocalDate date, int room_nr, int slot_nr){
        this.date = date;
        this.room_nr = room_nr;
        this.slot_nr = slot_nr;
    }

    public LocalDate getDate() {
        return date;
    }

    public void setDate(LocalDate date) {
        this.date = date;
    }

    public int getRoom_nr() {
        return room_nr;
    }

    public void setRoom_nr(int room_nr) {
        this.room_nr = room_nr;
    }

    public int getSlot_nr() {
        return slot_nr;
    }

    public void setSlot_nr(int slot_nr) {
        this.slot_nr = slot_nr;
    }
}
