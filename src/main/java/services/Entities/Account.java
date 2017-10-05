package services.Entities;

import services.DB.DB;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;

/**
 * Created by odd on 10/5/2017.
 */
public class Account {
    private int number;
    private int cvs;
    private String name;
    private int balance;

    public Account(){}

    public Account(int number, int cvs, String name, int balance) {
        this.number = number;
        this.cvs = cvs;
        this.name = name;
        this.balance = balance;
    }

    public int getNumber() {
        return number;
    }

    public void setNumber(int number) {
        this.number = number;
    }

    public int getCvs() {
        return cvs;
    }

    public void setCvs(int cvs) {
        this.cvs = cvs;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public int getBalance() {
        return balance;
    }

    public void setBalance(int balance) {
        this.balance = balance;
    }

    public static ArrayList<Account> getAll(){
        ArrayList<Account> out = new ArrayList<>();

        DB db = new DB();

        if(db.setUp()){
            try{
                db.prep = db.connection.prepareStatement("SELECT * FROM Account");

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

    public boolean checkBalance(int amount){
        boolean enoughFunds = false;

        DB db = new DB();

        if(db.setUp()){
            try{
                db.prep = db.connection.prepareStatement("SELECT * FROM Account WHERE number=?");
                db.prep.setInt(1, number);

                db.res = db.prep.executeQuery();

                if(db.res.next()){
                    Account account = processRow(db.res);
                    enoughFunds = account.equals(this) && account.balance >= amount;
                }
            }
            catch(SQLException e){
                e.printStackTrace();
            }
            finally{
                db.close();
            }
        }

        return enoughFunds;
    }

    public boolean pay(int amount){

        boolean success = false;

        DB db = new DB();

        if(db.setUp()){
            try{
                db.connection.setAutoCommit(false);
                db.prep = db.connection.prepareStatement("SELECT * FROM Account WHERE number=?");
                db.prep.setInt(1, number);

                db.res = db.prep.executeQuery();

                if(db.res.next()){
                    Account account = processRow(db.res);

                    db.res.close();
                    db.prep.close();

                    if(account.equals(this) && account.balance >= amount){

                        db.prep = db.connection.prepareStatement("UPDATE Account SET balance=? WHERE number=?");
                        db.prep.setInt(1, account.balance-amount);
                        db.prep.setInt(2, account.number);

                        success = (db.prep.executeUpdate() > 0); // if executeUpdate returns 0 something went wrong.
                        db.connection.commit();
                    }
                }
            }
            catch(SQLException e){
                e.printStackTrace();
            }
            finally{
                db.close();
            }
        }

        return success;
    }


    //Processes information fetched from database and creates a similar object.
    public static Account processRow(ResultSet res) throws SQLException {

        int number = res.getInt("Account.number");
        int cvs = res.getInt("Account.cvs");
        String name = res.getString("Account.name");
        int balance = res.getInt("Account.balance");

        return new Account(number, cvs, name, balance);
    }

    // Accounts are equal if account number and cvs are equal.
    public boolean equals(Object obj2){
        if(obj2 == null)
            return false;

        if(this == obj2)
            return true;

        Account acc2 = (Account) obj2;

        return (number == acc2.number && cvs == acc2.cvs);
    }
}
