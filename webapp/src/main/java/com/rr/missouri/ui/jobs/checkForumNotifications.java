/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.rr.missouri.ui.jobs;

import com.registryKit.forum.forumManager;
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
public class checkForumNotifications implements Job {
    
    @Autowired
    private forumManager forumManager;
    
    @Value("${programId}")
    private Integer programId;
    
    @Override
    public void execute(JobExecutionContext context)  throws JobExecutionException {
        
        try {
            SpringBeanAutowiringSupport.processInjectionBasedOnCurrentContext(this);
            forumManager.sendNotificationsJob(programId);          
        } catch (Exception ex) {
            try {
                throw new Exception("Error occurredfor sendNotificationsJob  - new type schedule task",ex);
            } catch (Exception ex1) {
                Logger.getLogger(checkForumNotifications.class.getName()).log(Level.SEVERE, null, ex1);
            }
        }
        
        
    }
    
}
