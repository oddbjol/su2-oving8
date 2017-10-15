package services.Entities;

import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.util.ArrayList;

/**
 * Created by odd2k on 15.10.2017.
 */
public class TableFreeSlot {
    public static final int SLOT_SIZE_MINS = 15;

    public int num_slots = 0;
    public Integer freeTable = -2; // -2 means not set. -1 means not free

    public static ArrayList<TableFreeSlot> getSlots(String from_date, int num_guests){

        String[] tokens = from_date.split("/");

        int year = Integer.parseInt(tokens[0]);
        int month = Integer.parseInt(tokens[1]);
        int day = Integer.parseInt(tokens[2]);

        LocalDateTime from_time = LocalDateTime.of(year, month, day, 12, 00);
        LocalDateTime end_time = LocalDateTime.of(year, month, day, 22, 00);

        ArrayList<TableFreeSlot> slots = new ArrayList<>();
        TableFreeSlot slot = new TableFreeSlot();

        while(from_time.isBefore(end_time)){

            LocalDateTime to_time = from_time.plusMinutes(90);

            FullOrder order = new FullOrder();
            order.from_time = Timestamp.valueOf(from_time);
            order.to_time = Timestamp.valueOf(to_time);
            order.num_guests = 3;

            int freeTable = ATable.findTable(order);

            int jump_time = TableFreeSlot.SLOT_SIZE_MINS;

            // We've just started.
            if(slot.freeTable == -2){
                if(freeTable == -1){    // No available table
                    slot.freeTable = -1;
                    slot.num_slots++;
                }
                else{
                    slot.freeTable = freeTable;
                    slot.num_slots = 90 / TableFreeSlot.SLOT_SIZE_MINS;
                }
            }
            else if(slot.freeTable == -1){ // Current slot is for no table
                if(freeTable == -1){ // Another spot with no table
                    slot.num_slots++;
                }
                else{ // We found a table
                    slots.add(slot);
                    slot = new TableFreeSlot();
                    slot.freeTable = freeTable;
                    slot.num_slots = 90 / TableFreeSlot.SLOT_SIZE_MINS;
                }
            }
            else{   //We are already filling out a table slot
                if(freeTable == -1 || freeTable != slot.freeTable){ // No suitable slot.
                    slots.add(slot);
                    slot = new TableFreeSlot();
                    slot.freeTable = freeTable;
                    slot.num_slots++;

                    jump_time = 90 - TableFreeSlot.SLOT_SIZE_MINS;
                }
                else{ // Keep filling up the table slot
                    slot.num_slots++;
                }
            }

            // Jump to next slot.
            from_time = from_time.plusMinutes(jump_time);
        }

        slots.add(slot);

        return slots;


    }
}
