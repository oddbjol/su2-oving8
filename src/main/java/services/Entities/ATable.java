package services.Entities;

import services.DB.DB;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;

/**
 * Created by odd on 10/5/2017.
 */
public class ATable {
    private int number;
    private int seats;

    public ATable(){}

    public ATable(int number, int seats) {
        this.number = number;
        this.seats = seats;
    }

    public int getNumber() {
        return number;
    }

    public void setNumber(int number) {
        this.number = number;
    }

    public int getSeats() {
        return seats;
    }

    public void setSeats(int seats) {
        this.seats = seats;
    }


    public static ArrayList<ATable> getAll(){
        ArrayList<ATable> out = new ArrayList<>();

        DB db = new DB();

        if(db.setUp()){
            try{
                db.prep = db.connection.prepareStatement("SELECT * FROM ATable");

                db.res = db.prep.executeQuery();

                while(db.res.next())
                    out.add(processRow(db.res));
            }
            catch(SQLException e){
                e.printStackTrace();
            }
            finally{
                db.close();
            }
        }

        return out;
    }


    public static ATable getById(int number){
        ATable out = null;

        DB db = new DB();

        if(db.setUp()){
            try{
                db.prep = db.connection.prepareStatement("SELECT * FROM ATable WHERE number=?");
                db.prep.setInt(1, number);
                db.res = db.prep.executeQuery();

                if(db.res.next())
                    out = processRow(db.res);
            }
            catch(SQLException e){
                e.printStackTrace();
            }
            finally{
                db.close();
            }
        }

        return out;
    }



    //Processes information fetched from database and creates a similar object.
    public static ATable processRow(ResultSet res) throws SQLException {

        int number = res.getInt("ATable.number");
        int seats = res.getInt("ATable.seats");

        return new ATable(number, seats);
    }
}
