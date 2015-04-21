/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.rr.missouri.ui.clients;

import java.util.Date;

/**
 *
 * @author chadmccue
 */
public class clientSummary {
    
    private String name;
    private String address;
    private String address2;
    private String city;
    private String state;
    private String zip;
    private String phoneNumber;
    private Date dob;
    private Date dateReferred;
    private String sourcePatientId;
    
    private String lastCompletedSurvey;

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public String getAddress2() {
        return address2;
    }

    public void setAddress2(String address2) {
        this.address2 = address2;
    }

    public String getCity() {
        return city;
    }

    public void setCity(String city) {
        this.city = city;
    }

    public String getState() {
        return state;
    }

    public void setState(String state) {
        this.state = state;
    }

    public String getZip() {
        return zip;
    }

    public void setZip(String zip) {
        this.zip = zip;
    }

    public String getPhoneNumber() {
        return phoneNumber;
    }

    public void setPhoneNumber(String phoneNumber) {
        this.phoneNumber = phoneNumber;
    }

    public Date getDob() {
        return dob;
    }

    public void setDob(Date dob) {
        this.dob = dob;
    }

    public String getLastCompletedSurvey() {
        return lastCompletedSurvey;
    }

    public void setLastCompletedSurvey(String lastCompletedSurvey) {
        this.lastCompletedSurvey = lastCompletedSurvey;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public Date getDateReferred() {
        return dateReferred;
    }

    public void setDateReferred(Date dateReferred) {
        this.dateReferred = dateReferred;
    }
    
    public String getSourcePatientId() {
        return sourcePatientId;
    }

    public void setSourcePatientId(String sourcePatientId) {
        this.sourcePatientId = sourcePatientId;
    }
    
}
