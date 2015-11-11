/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.rr.missouri.ui.forum;

import com.registryKit.forum.forumDocuments;
import com.registryKit.forum.forumEmailNotification;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import com.registryKit.forum.forumManager;
import com.registryKit.forum.forumMessages;
import com.registryKit.forum.forumNotificationPreferences;
import com.registryKit.forum.forumTopicEntities;
import com.registryKit.forum.forumTopics;
import com.registryKit.hierarchy.hierarchyManager;
import com.registryKit.hierarchy.programHierarchyDetails;
import com.registryKit.hierarchy.programOrgHierarchy;
import com.registryKit.user.User;
import com.registryKit.user.userManager;
import com.registryKit.user.userProgramModules;
import java.net.URLEncoder;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Date;
import java.util.List;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import org.springframework.web.servlet.view.RedirectView;

/**
 *
 * @author chadmccue
 */
@Controller
@RequestMapping("/forum")
public class forumController {

    private static Integer moduleId = 9;

    @Autowired
    forumManager forumManager;

    @Autowired
    private userManager usermanager;

    @Autowired
    private hierarchyManager hierarchymanager;

    @Value("${programId}")
    private Integer programId;

    @Value("${topSecret}")
    private String topSecret;

    private static boolean allowCreate = false;

    @RequestMapping(value = "", method = RequestMethod.GET)
    public ModelAndView forum(HttpSession session) throws Exception {

        /* Get a list of completed surveys the logged in user has access to */
        User userDetails = (User) session.getAttribute("userDetails");

        ModelAndView mav = new ModelAndView();
        mav.setViewName("/forum");
        
        /* Get a list of top level entities */
        Integer userId = 0;
        if (userDetails.getRoleId() == 3) {
            userId = userDetails.getId();
        }

        /* Get a list of announcment topics */
        List<forumTopics> announcementTopics = forumManager.getTopics(programId, 1, userId);
        mav.addObject("announcementTopics", announcementTopics);

        /* Get a list of regular topics */
        List<forumTopics> regularTopics = forumManager.getTopics(programId, 2, userId);
        mav.addObject("regularTopics", regularTopics);

        /* Get user permissions */
        userProgramModules modulePermissions = usermanager.getUserModulePermissions(programId, userDetails.getId(), moduleId);

        if (userDetails.getRoleId() == 2) {
            allowCreate = true;
        } else {
            allowCreate = modulePermissions.isAllowCreate();
        }

        mav.addObject("allowCreate", allowCreate);

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
            if (totalViews != null && totalViews > 0) {
                totalViews += 1;
            } else {
                totalViews = 1;
            }

            topicDetails.setTotalViews(totalViews);
            forumManager.updateTopic(topicDetails);

            mav.addObject("topicTitle", topicDetails.getTitle());
            mav.addObject("topicId", topicDetails.getId());
        }

        mav.addObject("allowCreate", allowCreate);

        return mav;

    }

    @RequestMapping(value = "/getTopicMessages.do", method = RequestMethod.GET)
    public @ResponseBody
    ModelAndView getTopicMessages(@RequestParam(value = "topicId", required = true) Integer topicId) throws Exception {

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
                        for(forumMessages reply : messageReplies) {
                            List<forumDocuments> documentList = forumManager.getMessageDocuments(reply.getId());

                            if (!documentList.isEmpty()) {
                                for(forumDocuments doc : documentList) {
                                    String encodedFileName = URLEncoder.encode(doc.getDocumentTitle(),"UTF-8");
                                    doc.setDocumentTitle(encodedFileName);
                                 }
                                reply.setForumDocuments(documentList);
                            }
                        }
                        message.setReplies(messageReplies);
                    }

                    List<forumDocuments> documentList = forumManager.getMessageDocuments(message.getId());

                    if (!documentList.isEmpty()) {
                        for(forumDocuments doc : documentList) {
                           String encodedFileName = URLEncoder.encode(doc.getDocumentTitle(),"UTF-8");
                           doc.setDocumentTitle(encodedFileName);
                        }
                        message.setForumDocuments(documentList);
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
                        for(forumMessages reply : messageReplies) {
                            List<forumDocuments> documentList = forumManager.getMessageDocuments(reply.getId());

                            if (!documentList.isEmpty()) {
                                for(forumDocuments doc : documentList) {
                                    String encodedFileName = URLEncoder.encode(doc.getDocumentTitle(),"UTF-8");
                                    doc.setDocumentTitle(encodedFileName);
                                 }
                                reply.setForumDocuments(documentList);
                            }
                        }
                        message.setReplies(messageReplies);
                    }

                    List<forumDocuments> documentList = forumManager.getMessageDocuments(message.getId());

                    if (!documentList.isEmpty()) {
                        for(forumDocuments doc : documentList) {
                            String encodedFileName = URLEncoder.encode(doc.getDocumentTitle(),"UTF-8");
                            doc.setDocumentTitle(encodedFileName);
                         }
                        message.setForumDocuments(documentList);
                    }

                    topicDateMessages.add(message);

                    date1 = date2;
                } else {
                    List<forumMessages> messageReplies = forumManager.getTopicMessageReplies(message.getId());

                    if (!messageReplies.isEmpty()) {
                        for(forumMessages reply : messageReplies) {
                            List<forumDocuments> documentList = forumManager.getMessageDocuments(reply.getId());

                            if (!documentList.isEmpty()) {
                                for(forumDocuments doc : documentList) {
                                    String encodedFileName = URLEncoder.encode(doc.getDocumentTitle(),"UTF-8");
                                    doc.setDocumentTitle(encodedFileName);
                                 }
                                reply.setForumDocuments(documentList);
                            }
                        }
                        message.setReplies(messageReplies);
                    }

                    List<forumDocuments> documentList = forumManager.getMessageDocuments(message.getId());

                    if (!documentList.isEmpty()) {
                        for(forumDocuments doc : documentList) {
                            String encodedFileName = URLEncoder.encode(doc.getDocumentTitle(),"UTF-8");
                            doc.setDocumentTitle(encodedFileName);
                         }
                        message.setForumDocuments(documentList);
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
        mav.addObject("allowCreate", allowCreate);

        return mav;

    }

    /**
     * The '/form/getTopicForm.do' GET request will return the topic message
     * form.
     *
     * @param topicId (required) The id of the selected topic
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/getTopicForm.do", method = RequestMethod.GET)
    public @ResponseBody
    ModelAndView getTopicForm(HttpSession session, @RequestParam(value = "topicId", required = true) Integer topicId) throws Exception {

        ModelAndView mav = new ModelAndView();
        mav.setViewName("/forum/topicFormModal");

        forumTopics topicDetails;

        if (topicId == 0) {
            topicDetails = new forumTopics();
        } else {
            topicDetails = forumManager.getTopicById(topicId);
            
            List<forumTopicEntities> entities = forumManager.getTopicEntities(programId, topicId);
            
            if(entities != null && entities.size() > 0) {
                List<Integer> entityList = new ArrayList<Integer>();
                for(forumTopicEntities entity : entities) {
                    entityList.add(entity.getEntityId());
                }
                topicDetails.setForumTopicEntities(entityList);
            }
            
        }
        mav.addObject("forumTopic", topicDetails);

        User userDetails = (User) session.getAttribute("userDetails");

        programOrgHierarchy topLevel = hierarchymanager.getProgramOrgHierarchyBydspPos(1, programId);

        /* Get a list of top level entities */
        Integer userId = 0;
        if (userDetails.getRoleId() == 3) {
            userId = userDetails.getId();
        }
        List<programHierarchyDetails> counties = hierarchymanager.getProgramHierarchyItems(topLevel.getId(), 0);

        mav.addObject("countyList", counties);
        mav.addObject("topLevelName", topLevel.getName());

        return mav;
    }

    /**
     * The 'saveTopicForm' POST request will handle saving the new/updated post
     * message.
     *
     * @param forumTopic
     * @param whichEntity
     * @param selectedEntities
     * @param session
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/saveTopicForm.do", method = RequestMethod.POST)
    public @ResponseBody
    Integer saveTopicForm(@ModelAttribute(value = "forumTopic") forumTopics forumTopic,
            @RequestParam(value = "whichEntity", required = true) Integer whichEntity,
            @RequestParam(value = "selectedEntities", required = false) List<Integer> selectedEntities,
            HttpSession session) throws Exception {

        /* Get a list of completed surveys the logged in user has access to */
        User userDetails = (User) session.getAttribute("userDetails");

        forumTopic.setProgramId(programId);

        /* Set the topic URL */
        String topicURL = forumTopic.getTitle().replaceAll("\\W", "-");

        /* Check to see it topic URL exists */
        forumTopics topicDetails = forumManager.getTopicByURL(topicURL);

        Integer topicNum = 0;
        String checktopicURL = topicURL;

        while (topicDetails != null) {
            topicNum++;

            checktopicURL = topicURL.concat("-" + topicNum);

            topicDetails = forumManager.getTopicByURL(checktopicURL);
        }

        forumTopic.setTopicURL(checktopicURL);

        Integer topicId = 0;
        
        /* Submit the initial message */
        boolean newTopic = true;
        forumMessages messageDetails = new forumMessages();
        Integer messageId = messageDetails.getId();
        if (forumTopic.getId() == 0) {
            topicId = forumManager.saveTopic(forumTopic);
            messageDetails.setTopicId(topicId);
            messageDetails.setMessage(forumTopic.getInitialMessage());
            messageDetails.setSystemUserId(userDetails.getId());
            messageDetails.setProgramId(programId);
            messageId = forumManager.saveTopicMessage(messageDetails);
        } else {
            forumManager.updateTopic(forumTopic);
            topicId = forumTopic.getId();
            newTopic = false;
        }
        
        /* Remove existing entities */
        forumManager.removeTopicEntities(programId, topicId);
        
        /* Enter the selected counties */
        if (whichEntity == 1) {
            /* Need to get all top entities for the program */
            programOrgHierarchy topLevel = hierarchymanager.getProgramOrgHierarchyBydspPos(1, programId);
            List<programHierarchyDetails> entities = hierarchymanager.getProgramHierarchyItems(topLevel.getId(), 0);

            if (entities != null && entities.size() > 0) {
                for (programHierarchyDetails entity : entities) {
                    forumTopicEntities topicEntity = new forumTopicEntities();
                    topicEntity.setEntityId(entity.getId());
                    topicEntity.setProgramId(programId);
                    topicEntity.setTopicId(topicId);
                    
                    forumManager.saveTopicEntities(topicEntity);
                }
            }
        } else if (whichEntity == 2 && selectedEntities != null && !"".equals(selectedEntities)) {
            for (Integer entity : selectedEntities) {
                forumTopicEntities topicEntity = new forumTopicEntities();
                topicEntity.setEntityId(entity);
                topicEntity.setProgramId(programId);
                topicEntity.setTopicId(topicId);
                
                forumManager.saveTopicEntities(topicEntity);
            }
        }

        if (newTopic) {
            forumEmailNotification fen  = new forumEmailNotification ();
            fen.setMessageId(messageDetails.getId());
            fen.setNotificationType(1);
            fen.setProgramId(programId);
            //insert so scheduler will pick it up and sent
            forumManager.saveForumEmailNotification(fen);
        }
        
        /* Return the topic Id */
        return topicId;
    }

    /**
     * The '/form/getPostForm.do' GET request will return the topic message
     * form.
     *
     * @param topicId (required) The id of the selected topic
     * @param postId (Optional) If passed in will hold the id of the selected
     * topic message, if 0 then new message
     * @param parentMessageId (Optional) If passed in will hold the id of the
     * message that the reply is for.
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/getPostForm.do", method = RequestMethod.GET)
    public @ResponseBody
    ModelAndView getPostForm(
            @RequestParam(value = "topicId", required = true) Integer topicId,
            @RequestParam(value = "postId", required = false, defaultValue = "0") Integer postId,
            @RequestParam(value = "parentMessageId", required = false, defaultValue = "0") Integer parentMessageId) throws Exception {

        ModelAndView mav = new ModelAndView();
        mav.setViewName("/forum/postFormModal");

        forumMessages messageDetails;

        if (postId == 0) {
            messageDetails = new forumMessages();
            messageDetails.setTopicId(topicId);
            messageDetails.setParentMessageId(parentMessageId);
        } else {
            messageDetails = forumManager.getTopicMessageDetails(postId);

            List<forumDocuments> documentList = forumManager.getMessageDocuments(postId);
            mav.addObject("documentList", documentList);

        }
        mav.addObject("forumMessage", messageDetails);

        return mav;
    }

    /**
     * The 'savePostForm' POST request will handle saving the new/updated post
     * message.
     *
     * @param forumMessage
     * @param errors
     * @param redirectAttr
     * @param session
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/savePostForm.do", method = RequestMethod.POST)
    public @ResponseBody
    ModelAndView savePostForm(@ModelAttribute(value = "forumMessage") forumMessages forumMessage,
            @RequestParam(value = "postDocuments", required = false) List<MultipartFile> postDocuments, RedirectAttributes redirectAttr,
            HttpSession session) throws Exception {

        /* Get a list of completed surveys the logged in user has access to */
        User userDetails = (User) session.getAttribute("userDetails");

        forumMessage.setSystemUserId(userDetails.getId());
        forumMessage.setProgramId(programId);
        Integer messageId = forumMessage.getId();
        if (forumMessage.getId() == 0) {
            messageId = forumManager.saveTopicMessage(forumMessage);
        } else {
            forumManager.updateTopicMessage(forumMessage);
        }
        
        if (postDocuments != null) {
            forumManager.saveDocuments(forumMessage, postDocuments);
        }

        forumTopics topicDetails = forumManager.getTopicById(forumMessage.getTopicId());

        /**post comments to my topics email**/
        
        forumEmailNotification fen  = new forumEmailNotification ();
        fen.setMessageId(forumMessage.getId());
        fen.setNotificationType(2);
        fen.setProgramId(programId);
        //insert so scheduler will pick it up and sent
        forumManager.saveForumEmailNotification(fen);
        
        /** post/comments made to topics I have posted to - this is only one email we send right away**/
        forumManager.sendMyPostsNotifications(forumMessage, topicDetails);
        
        
        ModelAndView mav = new ModelAndView(new RedirectView("/forum/" + topicDetails.getTopicURL()));
        return mav;

    }

    /**
     * The 'removePost' POST request will remove the clicked post.
     *
     * @param postId The id of the selected post to be removed.
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/removePost.do", method = RequestMethod.POST)
    public @ResponseBody
    Integer removePost(@RequestParam(value = "postId", required = true) Integer postId) throws Exception {

        forumManager.removeTopicMessage(postId);

        return 1;
    }

    /**
     * The 'removeForumTopic' POST request will remove the clicked post.
     *
     * @param topicId The id of the selected topic to be removed.
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/removeForumTopic.do", method = RequestMethod.POST)
    public @ResponseBody
    Integer removeTopic(@RequestParam(value = "topicId", required = true) Integer topicId) throws Exception {

        forumManager.removeTopic(topicId);

        return 1;
    }

    /**
     * The 'deleteDocument' POST request will remove the clicked uploaded
     * document.
     *
     * @param documentId The id of the clicked document.
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/deleteDocument.do", method = RequestMethod.POST)
    public @ResponseBody
    Integer deleteDocument(@RequestParam(value = "documentId", required = true) Integer documentId) throws Exception {

        forumManager.deleteDocumentById(documentId);

        return 1;
    }

    /**
     * The 'searchMessages' GET request will search the forum messages table.
     *
     * @param session
     * @param searchTerm The term to search on messages.
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "searchMessages.do", method = RequestMethod.GET)
    public @ResponseBody
    ModelAndView searchMessages(HttpSession session, @RequestParam(value = "searchTerm", required = true) String searchTerm) throws Exception {
        ModelAndView mav = new ModelAndView();
        mav.setViewName("/forum/searchResults");

        List<forumMessages> messages = forumManager.searchMessages(programId, searchTerm);

        if (messages != null && messages.size() > 0) {

            /* Highlight words */
            String[] colors = new String[7];
            colors[0] = "red";
            colors[1] = "green";
            colors[2] = "orange";
            colors[3] = "yellow";
            colors[4] = "purple";
            colors[5] = "pink";
            colors[6] = "blue";

            /* Limit returned text */
            for (forumMessages message : messages) {
                if (message.getMessage().length() > 200) {
                    message.setMessage(message.getMessage().substring(0, 200));
                }
            }

            Integer counter = 0;
            for (String word : searchTerm.split(" ")) {

                if (counter > 6) {
                    counter = 0;
                }
                
                String color = colors[counter];

                for (forumMessages message : messages) {
                    forumTopics topicDetails = forumManager.getTopicById(message.getTopicId());
                    
                    message.setTopicTitle(topicDetails.getTitle().toLowerCase().replaceAll(word, "<span class='" + color + "'>" + word + "</span>"));
                    message.setTopicURL(topicDetails.getTopicURL());

                    message.setMessage(message.getMessage().toLowerCase().replaceAll(word, "<span class='" + color + "'>" + word + "</span>"));
                }
                counter++;
                
            }
        }

        mav.addObject("foundMessages", messages);

        return mav;

    }
    
    @RequestMapping(value = "/getForumNotificationModel.do", method = RequestMethod.GET)
    public ModelAndView getForumNotificationModel(HttpSession session, HttpServletRequest request) throws Exception {

        ModelAndView mav = new ModelAndView();
        mav.setViewName("/forum/forumNotificationPreferences");

        User userDetails = (User) session.getAttribute("userDetails");

        forumNotificationPreferences notificationPreferences = forumManager.getNotificationPreferences(userDetails.getId());

        if (notificationPreferences != null) {
            mav.addObject("notificationPreferences", notificationPreferences);
        } else {
            forumNotificationPreferences newNotificationPreferences = new forumNotificationPreferences();
            newNotificationPreferences.setNotificationEmail(userDetails.getEmail());
            newNotificationPreferences.setProgramId(programId);
            mav.addObject("notificationPreferences", newNotificationPreferences);
        }
        
        programOrgHierarchy topLevel = hierarchymanager.getProgramOrgHierarchyBydspPos(1, programId);
        mav.addObject("topLevelName", topLevel.getName());

        return mav;
    }
    
    
    @RequestMapping(value = "/saveNotificationPreferences.do", method = RequestMethod.POST)
    public @ResponseBody
    Integer saveNotificationPreferences(@ModelAttribute(value = "notificationPreferences") forumNotificationPreferences notificationPreferences, BindingResult errors,
            HttpSession session, HttpServletRequest request) throws Exception {
        
        User userDetails = (User) session.getAttribute("userDetails");

        notificationPreferences.setSystemUserId(userDetails.getId());

        forumManager.saveNotificationPreferences(notificationPreferences);

        return 1;

    }

}