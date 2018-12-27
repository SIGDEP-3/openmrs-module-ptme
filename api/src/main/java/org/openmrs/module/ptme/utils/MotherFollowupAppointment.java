package org.openmrs.module.ptme.utils;

import java.util.Date;

/**
 * Created by yeo on 31/03/2018.
 */
public class MotherFollowupAppointment {

    private String hivCareNumber;
    private String pregnantNumber;
    private String familyName;
    private String givenName;
    private String contact;
    private Date lastVisitDate;
    private Integer numberOfVisit;
    private Date appointmentDate;
    private Integer passed;

    public MotherFollowupAppointment() {
    }

    public String getHivCareNumber() {
        return hivCareNumber;
    }

    public void setHivCareNumber(String hivCareNumber) {
        this.hivCareNumber = hivCareNumber;
    }

    public String getPregnantNumber() {
        return pregnantNumber;
    }

    public void setPregnantNumber(String pregnantNumber) {
        this.pregnantNumber = pregnantNumber;
    }

    public String getFamilyName() {
        return familyName;
    }

    public void setFamilyName(String familyName) {
        this.familyName = familyName;
    }

    public String getGivenName() {
        return givenName;
    }

    public void setGivenName(String givenName) {
        this.givenName = givenName;
    }

    public String getContact() {
        return contact;
    }

    public void setContact(String contact) {
        this.contact = contact;
    }

    public Date getLastVisitDate() {
        return lastVisitDate;
    }

    public void setLastVisitDate(Date lastVisitDate) {
        this.lastVisitDate = lastVisitDate;
    }

    public Integer getNumberOfVisit() {
        return numberOfVisit;
    }

    public void setNumberOfVisit(Integer numberOfVisit) {
        this.numberOfVisit = numberOfVisit;
    }

    public Date getAppointmentDate() {
        return appointmentDate;
    }

    public void setAppointmentDate(Date appointmentDate) {
        this.appointmentDate = appointmentDate;
    }

    public Integer getPassed() {
        return passed;
    }

    public void setPassed(Integer passed) {
        this.passed = passed;
    }
}
