/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.rr.missouri.ui.districts;

import java.util.List;

/**
 *
 * @author chadmccue
 */
public class county {
    
    public Integer countyId = 0;
    public String countyName = "";
    
    public List<district> districtList;
    

    public Integer getCountyId() {
        return countyId;
    }

    public void setCountyId(Integer countyId) {
        this.countyId = countyId;
    }

    public String getCountyName() {
        return countyName;
    }

    public void setCountyName(String countyName) {
        this.countyName = countyName;
    }

    public List<district> getDistrictList() {
        return districtList;
    }

    public void setDistrictList(List<district> districtList) {
        this.districtList = districtList;
    }
    
    
    
}
