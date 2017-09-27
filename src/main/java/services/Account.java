package services;

import java.io.Serializable;

/**
 * Created by KimRostgard on 27.09.2017.
 */
public class Account implements Serializable{
    private String cardnumber;
    private String expirationyear;
    private String expirationdate;
    private String cvs;
    private int balance;

    Account(){
    }

    public Account(String surname, String cardnumber, String expirationyear, String expirationdate, String cvs, int balance) {
        this.cardnumber = cardnumber;
        this.expirationyear = expirationyear;
        this.expirationdate = expirationdate;
        this.cvs = cvs;
        this.balance = balance;
    }




    public String getCardnumber() {
        return cardnumber;
    }

    public void setCardnumber(String cardnumber) {
        this.cardnumber = cardnumber;
    }

    public String getExpirationyear() {
        return expirationyear;
    }

    public void setExpirationyear(String expirationyear) {
        this.expirationyear = expirationyear;
    }

    public String getExpirationdate() {
        return expirationdate;
    }

    public void setExpirationdate(String expirationdate) {
        this.expirationdate = expirationdate;
    }

    public String getCvs() {
        return cvs;
    }

    public void setCvs(String cvs) {
        this.cvs = cvs;
    }

    public int getBalance() {
        return balance;
    }

    public void setBalance(int transaction) {
        this.balance += transaction;
    }

    public boolean equals(Object o){
        if(this == o)
            return true;

        if(o == null)
            return false;

        if (getClass() != o.getClass())
            return false;


        Account acc2 = (Account)o;

        return  (
                    cardnumber.equals(acc2.cardnumber) &&
                    cvs.equals(acc2.cvs) &&
                    expirationyear.equals(acc2.expirationyear) &&
                    expirationdate.equals(acc2.expirationdate)
                );
    }


}
