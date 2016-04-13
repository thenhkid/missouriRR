/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.rr.missouri.ui.jobs;


import com.registryKit.announcements.announcementManager;
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
 * @author gchan
 */
public class sendAnnouncementEmailNotifications implements Job {
    
    @Autowired
    private announcementManager announcementManager;
    
    @Value("${programId}")
    private Integer programId;
    
    @Override
    public void execute(JobExecutionContext context)  throws JobExecutionException {
        
        try {
            SpringBeanAutowiringSupport.processInjectionBasedOnCurrentContext(this);
            announcementManager.sendNotificationsJob(programId);  
        } catch (Exception ex) {
            try {
                throw new Exception("Error occurred send announcement notifications job from schedule task",ex);
            } catch (Exception ex1) {
                Logger.getLogger(sendAnnouncementEmailNotifications.class.getName()).log(Level.SEVERE, null, ex1);
            }
        }
        
        
    }
    
}
