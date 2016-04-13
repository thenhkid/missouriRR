/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.rr.missouri.ui.profile;

import com.registryKit.announcements.announcementManager;
import com.registryKit.announcements.announcementNotificationPreferences;
import com.registryKit.calendar.calendarManager;
import com.registryKit.calendar.calendarNotificationPreferences;
import com.registryKit.document.documentManager;
import com.registryKit.document.documentNotificationPreferences;
import com.registryKit.forum.forumManager;
import com.registryKit.forum.forumNotificationPreferences;
import com.registryKit.program.programManager;
import com.registryKit.resources.programResources;
import com.registryKit.resources.resourceManager;
import com.registryKit.user.User;
import com.registryKit.user.userManager;
import java.util.List;
import javax.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;

/**
 *
 * @author chadmccue
 */
@Controller
@RequestMapping("/profile")
public class profileController {

    @Autowired
    private userManager usermanager;
    
    @Autowired
    private programManager programManager;
    
    @Autowired
    resourceManager resourceManager;
    
    @Autowired
    calendarManager calendarManager;
    
    @Autowired
    private documentManager documentmanager;
    
    @Autowired
    private announcementManager announcementmanager;
    
    @Autowired
    forumManager forumManager;

    @Value("${programId}")
    private Integer programId;

    @Value("${topSecret}")
    private String topSecret;

    /**
     * The 'profile' GET method will return the user profile page.
     *
     * @param session
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "", method = RequestMethod.GET)
    public ModelAndView profile(HttpSession session) throws Exception {

        ModelAndView mav = new ModelAndView();
        mav.setViewName("/profile");

        /* Get a list of completed surveys the logged in user has access to */
        User userDetails = (User) session.getAttribute("userDetails");

        mav.addObject("userDetails", userDetails);

        /* Get a list of user resources */
        List<Integer> userResources = usermanager.getUserResources(userDetails.getId());
       
        boolean showSkillSets = false;
        boolean showCalendarNotifications = false;
        boolean showForumNotifications = false;
        boolean showDocumentNotifications = false;
        boolean showAnnouncementNotifications = false;
        
        if(session.getAttribute("availModules") != null) {
            
            String[][] modules = (String[][]) session.getAttribute("availModules");
            
            for (String[] module : modules) {
                Integer moduleId = Integer.valueOf(module[3]);
                if(null != moduleId) switch (moduleId) {
                    case 13:
                        List<programResources> programResources = resourceManager.getResources(programId);
                        if((programResources != null && programResources.size() > 0) && (userResources != null && userResources.size() > 0)) {
                            for(programResources resource : programResources) {
                                for(Integer userResource : userResources) {
                                    if(userResource == resource.getId()) {
                                        resource.setSelected(true);
                                    }
                                }
                            }
                        }   
                        mav.addObject("programResources", programResources);
                        showSkillSets = true;
                        break;
                    case 7:
                        calendarNotificationPreferences calendarNotificationPreferences = calendarManager.getNotificationPreferences(userDetails.getId());
                        mav.addObject("calendarNotificationPreferences", calendarNotificationPreferences);
                        showCalendarNotifications = true;
                        break;
                    case 9:
                        forumNotificationPreferences forumNotificationPreferences = forumManager.getNotificationPreferences(userDetails.getId());
                        mav.addObject("forumNotificationPreferences", forumNotificationPreferences);
                        showForumNotifications = true;
                        break;
                    case 10:
                        documentNotificationPreferences documentNotificationPreferences = documentmanager.getNotificationPreferences(userDetails.getId());
                        mav.addObject("documentNotificationPreferences", documentNotificationPreferences);
                        showDocumentNotifications = true;
                        break;
                   case 14:
                        announcementNotificationPreferences announcementNotificationPreferences = announcementmanager.getNotificationPreferences(userDetails.getId());
                        mav.addObject("announcementNotificationPreferences", announcementNotificationPreferences);
                        showAnnouncementNotifications = true;
                        break;
                    default:
                        break;
                }
            }
        }
       
        mav.addObject("showSkillSets",showSkillSets);
        mav.addObject("showCalendarNotifications",showCalendarNotifications);
        mav.addObject("showForumNotifications",showForumNotifications);
        mav.addObject("showDocumentNotifications",showDocumentNotifications);
        mav.addObject("showAnnouncementNotifications",showAnnouncementNotifications);
        
        return mav;
    }

    /**
     * The 'saveProfileForm.do' POST will save the user profile form.
     *
     * @param session
     * @param email
     * @param firstName
     * @param lastName
     * @param newPassword
     * @param profilePhoto
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "saveProfileForm.do", method = RequestMethod.POST)
    public ModelAndView submitProfileForm(HttpSession session, 
            @RequestParam(value = "updateAllEmails", required = false, defaultValue = "0") String updateAllEmails,
            @RequestParam String email,
            @RequestParam String username,
            @RequestParam String firstName,
            @RequestParam String lastName,
            @RequestParam String newPassword,
            @RequestParam(value = "profilePhoto", required = false) MultipartFile profilePhoto,
            @RequestParam String phoneNumber,
            @RequestParam Boolean privateProfile,
            @RequestParam(value = "selectedResources", required = false) List<Integer> selectedResources,
            @RequestParam(value = "calendarNotificationId", required = false) String calendarNotificationId,
            @RequestParam(value = "calendarnotificationEmail", required = false) String calendarnotificationEmail,
            @RequestParam(value = "newEventNotifications", required = false) Boolean newEventNotifications,
            @RequestParam(value = "modifyEventNotifications", required = false) Boolean modifyEventNotifications,
            @RequestParam(value = "forumNotificationId", required = false) String forumNotificationId,
            @RequestParam(value = "forumnotificationEmail", required = false) String forumnotificationEmail,
            @RequestParam(value = "newTopicsNotifications", required = false) Boolean newTopicsNotifications,
            @RequestParam(value = "repliesTopicsNotifications", required = false) Boolean repliesTopicsNotifications,
            @RequestParam(value = "myPostsNotifications", required = false) Boolean myPostsNotifications,
            @RequestParam(value = "documentNotificationId", required = false) String documentNotificationId,
            @RequestParam(value = "documentnotificationEmail", required = false) String documentnotificationEmail,
            @RequestParam(value = "myHierarchiesOnly", required = false) Boolean myHierarchiesOnly,
            @RequestParam(value = "allDocs", required = false) Boolean allDocs,
            @RequestParam(value = "announcementNotificationId", required = false) String announcementNotificationId,
            @RequestParam(value = "announcementnotificationEmail", required = false) String announcementnotificationEmail,
            @RequestParam(value = "announcementmyHierarchiesOnly", required = false) Boolean announcementmyHierarchiesOnly,
            @RequestParam(value = "allAnnouncements", required = false) Boolean allAnnouncements) throws Exception {

        ModelAndView mav = new ModelAndView();
        mav.setViewName("/profile");

        /* Get a list of completed surveys the logged in user has access to */
        User userDetails = (User) session.getAttribute("userDetails");
        
        /* Check for duplicate email address */
        User existingUser = usermanager.checkDuplicateUsername(username, programId, userDetails.getId());
        
        if (existingUser != null ) {
            mav.addObject("existingUser", "The username is already being used by another user.");
            return mav;
        }
        
        userDetails.setFirstName(firstName);
        userDetails.setLastName(lastName);
        userDetails.setEmail(email);
        userDetails.setUsername(username);
        userDetails.setPhoneNumber(phoneNumber);
        userDetails.setPrivateProfile(privateProfile);

        if (!"".equals(newPassword)) {
            userDetails.setPassword(newPassword);
            userDetails = usermanager.encryptPW(userDetails);
        }

        if (profilePhoto != null && !"".equals(profilePhoto) && profilePhoto.getSize() > 0) {
            String profilePhotoFileName = usermanager.saveProfilePhoto(programId, profilePhoto, userDetails);
            userDetails.setProfilePhoto(profilePhotoFileName);
        }

        usermanager.updateUser(userDetails);
        
        /* Delete user resources */
        usermanager.removeUserResources(userDetails.getId());
        
        /* Save user resources */
        if(selectedResources != null) {
            usermanager.saveUserResources(userDetails.getId(),selectedResources);
        }
        
        /* Check if Calendar Event Notifications need to be updated */
        if(calendarNotificationId != null && !"".equals(calendarNotificationId) && Integer.parseInt(calendarNotificationId) > 0) {
            calendarNotificationPreferences calendarNotificationPreferences = calendarManager.getNotificationPreferences(userDetails.getId());
            
            if(calendarnotificationEmail == null || "".equals(calendarnotificationEmail) || "1".equals(updateAllEmails)) {
                calendarnotificationEmail = email;
            }
            calendarNotificationPreferences.setNotificationEmail(calendarnotificationEmail);
            
            if(newEventNotifications == null) {
                newEventNotifications = false;
            }
            calendarNotificationPreferences.setNewEventNotifications(newEventNotifications);
            
            if(modifyEventNotifications == null) {
                modifyEventNotifications = false;
            }
            calendarNotificationPreferences.setModifyEventNotifications(modifyEventNotifications);
            
            calendarManager.saveNotificationPreferences(calendarNotificationPreferences);
        }
        else if(calendarNotificationId != null && "".equals(calendarNotificationId)) {
            calendarNotificationPreferences calendarNotificationPreferences = new calendarNotificationPreferences();
            calendarNotificationPreferences.setSystemUserId(userDetails.getId());
            if(calendarnotificationEmail == null || "".equals(calendarnotificationEmail) || "1".equals(updateAllEmails)) {
                calendarnotificationEmail = email;
            }
            calendarNotificationPreferences.setNotificationEmail(calendarnotificationEmail);
            if(newEventNotifications == null) {
                newEventNotifications = false;
            }
            calendarNotificationPreferences.setNewEventNotifications(newEventNotifications);
            
            if(modifyEventNotifications == null) {
                modifyEventNotifications = false;
            }
            calendarNotificationPreferences.setModifyEventNotifications(modifyEventNotifications);
            calendarNotificationPreferences.setProgramId(programId);

            calendarManager.saveNotificationPreferences(calendarNotificationPreferences);
        }
        
        /* Check if Forum Notifications need to be updated */
        if(forumNotificationId != null && !"".equals(forumNotificationId) && Integer.parseInt(forumNotificationId) > 0) {
            forumNotificationPreferences forumNotificationPreferences = forumManager.getNotificationPreferences(userDetails.getId());
            
            if(forumnotificationEmail == null || "".equals(forumnotificationEmail) || "1".equals(updateAllEmails)) {
                forumnotificationEmail = email;
            }
            forumNotificationPreferences.setNotificationEmail(forumnotificationEmail);
            
            if(newTopicsNotifications == null) {
                newTopicsNotifications = false;
            }
            forumNotificationPreferences.setNewTopicsNotifications(newTopicsNotifications);
            
            if(repliesTopicsNotifications == null) {
                repliesTopicsNotifications = false;
            }
            forumNotificationPreferences.setRepliesTopicsNotifications(repliesTopicsNotifications);
            
            if(myPostsNotifications == null) {
                myPostsNotifications = false;
            }
            forumNotificationPreferences.setMyPostsNotifications(myPostsNotifications);
            
            forumManager.saveNotificationPreferences(forumNotificationPreferences);
        }
        else if(forumNotificationId != null && "".equals(forumNotificationId)) {
            forumNotificationPreferences forumNotificationPreferences = new forumNotificationPreferences();
            forumNotificationPreferences.setSystemUserId(userDetails.getId());
            forumNotificationPreferences.setProgramId(programId);
            
            if(forumnotificationEmail == null || "".equals(forumnotificationEmail) || "1".equals(updateAllEmails)) {
                forumnotificationEmail = email;
            }
            forumNotificationPreferences.setNotificationEmail(forumnotificationEmail);
            
            if(newTopicsNotifications == null) {
                newTopicsNotifications = false;
            }
            forumNotificationPreferences.setNewTopicsNotifications(newTopicsNotifications);
            
            if(repliesTopicsNotifications == null) {
                repliesTopicsNotifications = false;
            }
            forumNotificationPreferences.setRepliesTopicsNotifications(repliesTopicsNotifications);
            
            if(myPostsNotifications == null) {
                myPostsNotifications = false;
            }
            forumNotificationPreferences.setMyPostsNotifications(myPostsNotifications);
            
            forumManager.saveNotificationPreferences(forumNotificationPreferences);
        }
                
        /* Check if Document Notifications need to be updated */
        if(documentNotificationId != null && !"".equals(documentNotificationId) && Integer.parseInt(documentNotificationId) > 0) {
            documentNotificationPreferences documentNotificationPreferences = documentmanager.getNotificationPreferences(userDetails.getId());
            
            if(documentnotificationEmail == null || "".equals(documentnotificationEmail) || "1".equals(updateAllEmails)) {
                documentnotificationEmail = email;
            }
            documentNotificationPreferences.setNotificationEmail(documentnotificationEmail);
            
            if(myHierarchiesOnly == null) {
                myHierarchiesOnly = false;
            }
            documentNotificationPreferences.setMyHierarchiesOnly(myHierarchiesOnly);
            
            if(allDocs == null) {
                allDocs = false;
            }
            documentNotificationPreferences.setAllDocs(allDocs);
            
            documentmanager.saveNotificationPreferences(documentNotificationPreferences);
        }        
         else if(documentNotificationId != null && "".equals(documentNotificationId)) {
            documentNotificationPreferences documentNotificationPreferences = new documentNotificationPreferences();
            documentNotificationPreferences.setProgramId(programId);
            documentNotificationPreferences.setSystemUserId(userDetails.getId());
            
            if(documentnotificationEmail == null || "".equals(documentnotificationEmail) || "1".equals(updateAllEmails)) {
                documentnotificationEmail = email;
            }
            documentNotificationPreferences.setNotificationEmail(documentnotificationEmail);
            
            if(myHierarchiesOnly == null) {
                myHierarchiesOnly = false;
            }
            documentNotificationPreferences.setMyHierarchiesOnly(myHierarchiesOnly);
            
            if(allDocs == null) {
                allDocs = false;
            }
            documentNotificationPreferences.setAllDocs(allDocs);
            
            documentmanager.saveNotificationPreferences(documentNotificationPreferences);
        }
        
        /* Check if Announcement Notifications need to be updated */
        if(announcementNotificationId != null && !"".equals(announcementNotificationId) && Integer.parseInt(announcementNotificationId) > 0) {
            announcementNotificationPreferences announcementNotificationPreferences = announcementmanager.getNotificationPreferences(userDetails.getId());
            
            if(announcementnotificationEmail == null || "".equals(announcementnotificationEmail) || "1".equals(updateAllEmails)) {
                announcementnotificationEmail = email;
            }
            announcementNotificationPreferences.setNotificationEmail(announcementnotificationEmail);
            
            if(announcementmyHierarchiesOnly == null) {
                announcementmyHierarchiesOnly = false;
            }
            announcementNotificationPreferences.setMyHierarchiesOnly(announcementmyHierarchiesOnly);
            
            if(allAnnouncements == null) {
                allAnnouncements = false;
            }
            announcementNotificationPreferences.setAllAnnouncements(allAnnouncements);
            
            announcementmanager.saveNotificationPreferences(announcementNotificationPreferences);
        }        
         else if(announcementNotificationId != null && "".equals(announcementNotificationId)) {
            announcementNotificationPreferences announcementNotificationPreferences = new announcementNotificationPreferences();
            announcementNotificationPreferences.setProgramId(programId);
            announcementNotificationPreferences.setSystemUserId(userDetails.getId());
            
            if(announcementnotificationEmail == null || "".equals(announcementnotificationEmail) || "1".equals(updateAllEmails)) {
                announcementnotificationEmail = email;
            }
            announcementNotificationPreferences.setNotificationEmail(announcementnotificationEmail);
            
            if(announcementmyHierarchiesOnly == null) {
                announcementmyHierarchiesOnly = false;
            }
            announcementNotificationPreferences.setMyHierarchiesOnly(announcementmyHierarchiesOnly);
            
            if(allAnnouncements == null) {
                allAnnouncements = false;
            }
            announcementNotificationPreferences.setAllAnnouncements(allAnnouncements);
            
            announcementmanager.saveNotificationPreferences(announcementNotificationPreferences);
        }
        
        mav.addObject("savedStatus", "updated");
        
        /* Get a list of user resources */
        List<Integer> userResources = usermanager.getUserResources(userDetails.getId());
        
        boolean showSkillSets = false;
        boolean showCalendarNotifications = false;
        boolean showForumNotifications = false;
        boolean showDocumentNotifications = false;
        boolean showAnnouncementNotifications = false;
        
        if(session.getAttribute("availModules") != null) {
            
            String[][] modules = (String[][]) session.getAttribute("availModules");
            
            for (String[] module : modules) {
                Integer moduleId = Integer.valueOf(module[3]);
                if(null != moduleId) switch (moduleId) {
                    case 13:
                        List<programResources> programResources = resourceManager.getResources(programId);
                        if((programResources != null && programResources.size() > 0) && (userResources != null && userResources.size() > 0)) {
                            for(programResources resource : programResources) {
                                for(Integer userResource : userResources) {
                                    if(userResource == resource.getId()) {
                                        resource.setSelected(true);
                                    }
                                }
                            }
                        }   
                        mav.addObject("programResources", programResources);
                        showSkillSets = true;
                        break;
                    case 7:
                        calendarNotificationPreferences calendarNotificationPreferences = calendarManager.getNotificationPreferences(userDetails.getId());
                        mav.addObject("calendarNotificationPreferences", calendarNotificationPreferences);
                        showCalendarNotifications = true;
                        break;
                    case 9:
                        forumNotificationPreferences forumNotificationPreferences = forumManager.getNotificationPreferences(userDetails.getId());
                        mav.addObject("forumNotificationPreferences", forumNotificationPreferences);
                        showForumNotifications = true;
                        break;
                    case 10:
                        documentNotificationPreferences documentNotificationPreferences = documentmanager.getNotificationPreferences(userDetails.getId());
                        mav.addObject("documentNotificationPreferences", documentNotificationPreferences);
                        showDocumentNotifications = true;
                        break;
                    case 14:
                        announcementNotificationPreferences announcementNotificationPreferences = announcementmanager.getNotificationPreferences(userDetails.getId());
                        mav.addObject("announcementNotificationPreferences", announcementNotificationPreferences);
                        showAnnouncementNotifications = true;
                        break;    
                    default:
                        break;
                }
            }
        }
       
        mav.addObject("showSkillSets",showSkillSets);
        mav.addObject("showCalendarNotifications",showCalendarNotifications);
        mav.addObject("showForumNotifications",showForumNotifications);
        mav.addObject("showDocumentNotifications",showDocumentNotifications);
        mav.addObject("showAnnouncementNotifications",showAnnouncementNotifications);
        
        return mav;
    }

    /**
     * The 'removePhoto' POST method will remove the uploaded profile photo.
     *
     * @param session
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "removePhoto", method = RequestMethod.POST)
    public @ResponseBody
    Integer removeProfilePhoto(HttpSession session) throws Exception {

        User userDetails = (User) session.getAttribute("userDetails");
        userDetails.setProfilePhoto("");

        usermanager.updateUser(userDetails);

        return 1;
    }

}
