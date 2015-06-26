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
import com.registryKit.user.User;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Date;
import java.util.List;
import javax.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.validation.BindingResult;
import org.springframework.validation.ObjectError;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

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
        List<forumTopics> announcementTopics = forumManager.getTopics(programId, 1);
        mav.addObject("announcementTopics", announcementTopics);

        /* Get a list of regular topics */
        List<forumTopics> regularTopics = forumManager.getTopics(programId, 2);
        mav.addObject("regularTopics", regularTopics);

        return mav;
    }

    /**
     * The '/forum/${pathVariable}' GET request will return the message for the
     * clicked topic.
     *
     * @param pathVariable Will hold the url for the clicked variable
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/{pathVariable}", method = RequestMethod.GET)
    public ModelAndView forumTopicMessages(@PathVariable String pathVariable) throws Exception {
        
        ModelAndView mav = new ModelAndView();
        mav.setViewName("/topicMessages");

        forumTopics topicDetails = forumManager.getTopicByURL(pathVariable);
        
        if (topicDetails != null) {
        
            /* Need to log a view */
            Integer totalViews = topicDetails.getTotalViews();
            if(totalViews != null && totalViews > 0) {
                totalViews+=1;
            }
            else {
                totalViews = 1;
            }
            topicDetails.setTotalViews(totalViews);
            forumManager.saveTopic(topicDetails);

            mav.addObject("topicTitle", topicDetails.getTitle());
            mav.addObject("topicId", topicDetails.getId());
        }

        return mav;

    }
    
    @RequestMapping(value = "/getTopicMessages.do", method = RequestMethod.GET)
    public @ResponseBody ModelAndView getTopicMessages(@RequestParam(value = "topicId", required = true) Integer topicId) throws Exception {
        
        List<topicMessages> topicMessages = new ArrayList<topicMessages>();

        List<forumMessages> messages = forumManager.getTopicMessages(topicId);

        if (!messages.isEmpty()) {
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
            Date date1 = null;
            topicMessages newmessage = null;
            List<forumMessages> topicDateMessages = new ArrayList<forumMessages>();

            for (forumMessages message : messages) {
                Date date2 = sdf.parse(message.getDateCreated().toString());

                if (date1 == null) {
                    date1 = date2;

                    newmessage = new topicMessages();
                    newmessage.setMessageDate(message.getDateCreated());

                    List<forumMessages> messageReplies = forumManager.getTopicMessageReplies(message.getId());

                    if (!messageReplies.isEmpty()) {
                        message.setReplies(messageReplies);
                    }
                    topicDateMessages.add(message);

                } else if (date2.before(date1)) {
                    newmessage.setMessages(topicDateMessages);
                    topicMessages.add(newmessage);

                    newmessage = new topicMessages();
                    topicDateMessages = new ArrayList<forumMessages>();
                    newmessage.setMessageDate(message.getDateCreated());

                    List<forumMessages> messageReplies = forumManager.getTopicMessageReplies(message.getId());

                    if (!messageReplies.isEmpty()) {
                        message.setReplies(messageReplies);
                    }

                    topicDateMessages.add(message);

                    date1 = date2;
                } else {
                    List<forumMessages> messageReplies = forumManager.getTopicMessageReplies(message.getId());

                    if (!messageReplies.isEmpty()) {
                        message.setReplies(messageReplies);
                    }

                    topicDateMessages.add(message);
                }
            }

            /* Add last entry */
            newmessage.setMessages(topicDateMessages);
            topicMessages.add(newmessage);
        }

        Collections.sort(topicMessages, Collections.reverseOrder());
        
        ModelAndView mav = new ModelAndView();
        mav.setViewName("/forum/messages");
        mav.addObject("topicMessages", topicMessages);
        
        return mav;
        
    }
    
    
    /**
     * The '/form/getPostForm.do' GET request will return the topic message form.
     * 
     * @param topicId (requried) The id of the selected topic
     * @param postId  (Optional) If passed in will hold the id of the selected topic message, if 0 then new message
     * @param parentMessageId   (Optional) If passed in will hold the id of the message that the reply is for.
     * @return
     * @throws Exception 
     */
    @RequestMapping(value = "/getPostForm.do", method = RequestMethod.GET)
    public @ResponseBody ModelAndView getPostForm(
            @RequestParam(value = "topicId", required = true) Integer topicId, 
            @RequestParam(value = "postId", required = false, defaultValue = "0") Integer postId,
            @RequestParam(value = "parentMessageId", required = false, defaultValue = "0") Integer parentMessageId) throws Exception {
        
        ModelAndView mav = new ModelAndView();
        mav.setViewName("/forum/postFormModal");
        
        forumMessages messageDetails;
        
        if(postId == 0) {
            messageDetails = new forumMessages();
            messageDetails.setTopicId(topicId);
            messageDetails.setParentMessageId(parentMessageId);
        }
        else {
            messageDetails = forumManager.getTopicMessageDetails(postId);
        }
        mav.addObject("forumMessage", messageDetails);
        
        
        return mav;
    }
    
    /**
     * The 'savePostForm' POST request will handle saving the new/updated post message.
     * @param forumMessage
     * @param errors
     * @param redirectAttr
     * @param session
     * @return
     * @throws Exception 
     */
    @RequestMapping(value = "/savePostForm.do", method = RequestMethod.POST)
    public @ResponseBody Integer savePostForm(@ModelAttribute(value = "forumMessage") forumMessages forumMessage, HttpSession session) throws Exception {
      
        /* Get a list of completed surveys the logged in user has access to */
        User userDetails = (User) session.getAttribute("userDetails");
        
        forumMessage.setSystemUserId(userDetails.getId());
        
        forumManager.saveTopicMessage(forumMessage);
        
        /* Return the topic Id */
        return forumMessage.getTopicId();
    }
    
    /**
     * The 'removePost' POST request will remove the clicked post.
     * 
     * @param postId    The id of the selected post to be removed.
     * @return
     * @throws Exception 
     */
    @RequestMapping(value = "/removePost.do", method = RequestMethod.POST)
    public @ResponseBody Integer removePost(@RequestParam(value = "postId", required = true) Integer postId) throws Exception {
        
        forumManager.removeTopicMessage(postId);
        
        return 1;
    }
}
