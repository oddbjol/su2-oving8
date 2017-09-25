package services;

import java.io.Serializable;
import java.util.HashMap;
import java.util.Map;

/**
 * Created by KimRostgard on 25.09.2017.
 */
public class MultiHashMap implements Serializable {
    private HashMap<String, HashMap<Integer, HashMap<Integer, Order>>> map;

    public HashMap<String, HashMap<Integer, HashMap<Integer, Order>>> getMap() {
        return map;
    }

    public void setMap(HashMap<String, HashMap<Integer, HashMap<Integer, Order>>> map) {
        this.map = map;
    }

    public MultiHashMap() {
        map = new HashMap<String, HashMap<Integer, HashMap<Integer, Order>>>();
    }

    public boolean put(String date, Integer bordnr, Integer slotnr, Order value){
        if(map.get(date) == null) {
            map.put(date, new HashMap<Integer, HashMap<Integer, Order>>());
        }
        if(map.get(date).get(bordnr) == null){
            map.get(date).put(bordnr,new HashMap<Integer, Order>());
        }
        if(map.get(date).get(bordnr).containsKey(slotnr))
            return false;
        else{
            map.get(date).get(bordnr).put(slotnr, value);
            return true;
        }

    }

    public HashMap<Integer, HashMap<Integer, Order>> getOrdersByDate(String date){
        return map.get(date);
    }

    public boolean isFree(String dato, int bordnr, int slotnr){
        return !(map.containsKey(dato) && map.get(dato).containsKey(bordnr) && map.get(dato).get(bordnr).containsKey(slotnr));
    }
}