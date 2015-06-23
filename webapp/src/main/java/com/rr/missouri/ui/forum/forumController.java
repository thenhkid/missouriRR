/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.rr.missouri.ui.forum;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import com.registryKit.forum.forumManager;
import com.registryKit.forum.forumMessages;
import com.registryKit.forum.forumTopics;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Date;
import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.ModelAndView;

/**
 *
 * @author chadmccue
 */
@Controller
@RequestMapping("/forum")
public class forumController {
    
   @Autowired
   forumManager forumManager;
    
   @Value("${programId}")
   private Integer programId;
   
   @Value("${topSecret}")
   private String topSecret;
   
   @RequestMapping(value = "", method = RequestMethod.GET)
    public ModelAndView forum() throws Exception {
        
        ModelAndView mav = new ModelAndView();
        mav.setViewName("/forum");
        
        /* Get a list of announcment topics */
        List<forumTopics> announcementTopics = forumManager.getTopics(programId,1);
        mav.addObject("announcementTopics", announcementTopics);
        
        /* Get a list of regular topics */
        List<forumTopics> regularTopics = forumManager.getTopics(programId,2);
        mav.addObject("regularTopics", regularTopics);
        
        return mav;
    }
    
    /**
     * The '/forum/${pathVariable}' GET request will return the message for the clicked topic.
     * 
     * @param pathVariable Will hold the url for the clicked variable
     * @return
     * @throws Exception 
     */
    @RequestMapping(value = "/{pathVariable}", method = RequestMethod.GET)
    public ModelAndView forumTopicMessages(@PathVariable String pathVariable) throws Exception {
        
        Integer topicId = forumManager.getTopicByURL(pathVariable);
        
        List<topicMessages> topicMessages = new ArrayList<topicMessages>();
        
        if(topicId > 0) {
             List<forumMessages> messages = forumManager.getTopicMessages(topicId);
             
             if(!messages.isEmpty()) {
                 SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
                 Date date1 = null;
                 topicMessages newmessage = null;
                 List<forumMessages> topicDateMessages = new ArrayList<forumMessages>();
                 
                 System.out.println(messages.size());
                 for(forumMessages message : messages) {
                     Date date2 = sdf.parse(message.getDateCreated().toString());
                     System.out.println("Date 1 = " + date1);
                     System.out.println("Date 2 = " + date2);
                     System.out.println(message.getMessage());
                     if(date1 == null) {
                         date1 = date2;
                         
                         newmessage = new topicMessages();
                         newmessage.setMessageDate(message.getDateCreated());
                         topicDateMessages.add(message);
                     }
                     else if(date2.after(date1)) {
                         newmessage.setMessages(topicDateMessages);
                         topicMessages.add(newmessage);
                         
                         newmessage = new topicMessages();
                         newmessage.setMessageDate(message.getDateCreated());
                         topicDateMessages.add(message);
                         
                         date1 = date2;
                     }
                     else {
                        List<forumMessages> messageReplies = forumManager.getTopicMessageReplies(message.getId());
                        
                        if(!messageReplies.isEmpty()) {
                            message.setReplies(messageReplies);
                        }
                        
                        topicDateMessages.add(message);
                     }
                 }
             }
        }
        
        Collections.sort(topicMessages);
       
        ModelAndView mav = new ModelAndView();
        mav.setViewName("/topicMessages");
        mav.addObject("topicMessages", topicMessages);
        
        return mav;
        
    }
}
