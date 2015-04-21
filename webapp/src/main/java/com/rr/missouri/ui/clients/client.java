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
public class client {
    
    private int clientId;
    private String name;
    private String email;
    private String address;
    private String address2;
    private String city;
    private String state;
    private String zip;
    private String phoneNumber;
    private String staffMember;
    private String enrollment;
    private Date DOB;
    private String sourcePatientId;
    
    private Date dateReferred;
    private Date lastEngagement;
    
    private String encryptedId = null;
    private String encryptedSecret = null;
    private Integer similarMatches = 0;

    public int getClientId() {
        return clientId;
    }

    public void setClientId(int clientId) {
        this.clientId = clientId;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

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

    public String getStaffMember() {
        return staffMember;
    }

    public void setStaffMember(String staffMember) {
        this.staffMember = staffMember;
    }

    public String getEnrollment() {
        return enrollment;
    }

    public void setEnrollment(String enrollment) {
        this.enrollment = enrollment;
    }

    public Date getDateReferred() {
        return dateReferred;
    }

    public void setDateReferred(Date dateReferred) {
        this.dateReferred = dateReferred;
    }

    public Date getLastEngagement() {
        return lastEngagement;
    }

    public void setLastEngagement(Date lastEngagement) {
        this.lastEngagement = lastEngagement;
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

    public Integer getSimilarMatches() {
        return similarMatches;
    }

    public void setSimilarMatches(Integer similarMatches) {
        this.similarMatches = similarMatches;
    }

    public Date getDOB() {
        return DOB;
    }

    public void setDOB(Date DOB) {
        this.DOB = DOB;
    }

    public String getSourcePatientId() {
        return sourcePatientId;
    }

    public void setSourcePatientId(String sourcePatientId) {
        this.sourcePatientId = sourcePatientId;
    }
    
}
