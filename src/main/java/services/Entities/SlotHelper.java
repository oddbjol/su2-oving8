package services.Entities;

import java.io.Serializable;

/**
 * Created by odd2k on 15.10.2017.
 */
public class SlotHelper implements Serializable {
    public String date;
    public int numGuests;

    public SlotHelper(){}

    public String getDate() {
        return date;
    }

    public void setDate(String date) {
        this.date = date;
    }

    public int getNumGuests() {
        return numGuests;
    }

    public void setNumGuests(int numGuests) {
        this.numGuests = numGuests;
    }
}
