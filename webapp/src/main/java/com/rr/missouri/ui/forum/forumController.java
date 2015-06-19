/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.rr.missouri.ui.forum;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import com.registryKit.forum.forumManager;
import com.registryKit.forum.forumTopics;
import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
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
}
