/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.rr.missouri.ui.jobs;

import com.registryKit.calendar.calendarManager;
import java.util.logging.Level;
import java.util.logging.Logger;
import org.quartz.Job;
import org.quartz.JobExecutionContext;
import org.quartz.JobExecutionException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.web.context.support.SpringBeanAutowiringSupport;

/**
 *
 * @author chadmccue
 */
public class checkCalendarNotifications implements Job {
    
    @Autowired
    private calendarManager calendarManager;
    
    @Value("${programId}")
    private Integer programId;
    
    
    /*
    * this sends reminders
    */
    
    @Override
    public void execute(JobExecutionContext context)  throws JobExecutionException {
        
        try {
            SpringBeanAutowiringSupport.processInjectionBasedOnCurrentContext(this);
            calendarManager.checkCalendarNotifications(programId);          
        } catch (Exception ex) {
            try {
                throw new Exception("Error occurred checkCalendarNotifications from schedule task",ex);
            } catch (Exception ex1) {
                Logger.getLogger(checkCalendarNotifications.class.getName()).log(Level.SEVERE, null, ex1);
            }
        }
        
        
    }
    
}
