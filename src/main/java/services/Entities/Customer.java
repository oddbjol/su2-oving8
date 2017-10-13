package services.Entities;

import services.DB.DB;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;

/**
 * Created by odd on 10/5/2017.
 */
public class Customer {
    private int id;
    private String name;
    private String surname;
    private String email;
    private String password;
    private Integer card_number;
    private Integer card_cvs;

    public Customer(){}

    public Customer(int id, String name, String surname, String email, String password, Integer card_number, Integer card_cvs) {
        this.id = id;
        this.name = name;
        this.surname = surname;
        this.email = email;
        this.password = password;
        this.card_number = (card_number == 0 ? null : card_number);
        this.card_cvs = (card_cvs == 0 ? null : card_cvs);
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getSurname() {
        return surname;
    }

    public void setSurname(String surname) {
        this.surname = surname;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public Integer getCard_number() {
        return card_number;
    }

    public void setCard_number(Integer card_number) {
        this.card_number = card_number;
    }

    public Integer getCard_cvs() {
        return card_cvs;
    }

    public void setCard_cvs(Integer card_cvs) {
        this.card_cvs = card_cvs;
    }

    /**
     * Retrieve all registered customers from database.
     *
     * @return
     */

    public static ArrayList<Customer> getAll(){
        ArrayList<Customer> out = new ArrayList<>();

        DB db = new DB();

        if(db.setUp()){
            try{
                db.prep = db.connection.prepareStatement("SELECT * FROM Customer");

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

    public static Customer getById(int id){
        Customer out = null;

        DB db = new DB();

        if(db.setUp()){
            try{
                db.prep = db.connection.prepareStatement("SELECT * FROM Customer WHERE id=?");
                db.prep.setInt(1, id);
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
    public static Customer processRow(ResultSet res) throws SQLException {

        int id = res.getInt("Customer.id");
        String name = res.getString("Customer.name");
        String surname = res.getString("Customer.surname");
        String email = res.getString("Customer.email");
        String password = res.getString("Customer.password");
        int card_number = res.getInt("Customer.card_number");
        int card_cvs = res.getInt("Customer.card_cvs");

        return new Customer(id, name, surname, email, password, card_number, card_cvs);
    }
}
