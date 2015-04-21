/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.rr.missouri.ui.districts;

import java.util.Date;

/**
 *
 * @author chadmccue
 */
public class district {
    
    private String districtName;
    private Integer districtId;
    private String lastSurveyTaken;
    private Date lastSurveyTakenOn;
    
    private String encryptedId = null;
    private String encryptedSecret = null;

    public String getDistrictName() {
        return districtName;
    }

    public void setDistrictName(String districtName) {
        this.districtName = districtName;
    }

    public Integer getDistrictId() {
        return districtId;
    }

    public void setDistrictId(Integer districtId) {
        this.districtId = districtId;
    }

    public String getLastSurveyTaken() {
        return lastSurveyTaken;
    }

    public void setLastSurveyTaken(String lastSurveyTaken) {
        this.lastSurveyTaken = lastSurveyTaken;
    }

    public Date getLastSurveyTakenOn() {
        return lastSurveyTakenOn;
    }

    public void setLastSurveyTakenOn(Date lastSurveyTakenOn) {
        this.lastSurveyTakenOn = lastSurveyTakenOn;
    }

    public String getEncryptedId() {
        return encryptedId;
    }

    public void setEncryptedId(String encryptedId) {
        this.encryptedId = encryptedId;
    }

    public String getEncryptedSecret() {
        return encryptedSecret;
    }

    public void setEncryptedSecret(String encryptedSecret) {
        this.encryptedSecret = encryptedSecret;
    }
    
    
}
