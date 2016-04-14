/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.rr.missouri.ui.announcements;

import com.registryKit.announcements.announcement;
import com.registryKit.announcements.announcementDocuments;
import com.registryKit.announcements.announcementEmailNotifications;
import com.registryKit.announcements.announcementEntities;
import com.registryKit.announcements.announcementManager;
import com.registryKit.announcements.announcementNotificationPreferences;
import com.registryKit.hierarchy.hierarchyManager;
import com.registryKit.hierarchy.programHierarchyDetails;
import com.registryKit.hierarchy.programOrgHierarchy;
import com.registryKit.program.programManager;
import com.registryKit.reference.fileSystem;
import com.registryKit.user.User;
import com.registryKit.user.userManager;
import com.registryKit.user.userProgramModules;
import com.rr.missouri.ui.security.decryptObject;
import com.rr.missouri.ui.security.encryptObject;
import java.io.File;
import java.net.URLEncoder;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
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
@RequestMapping("/announcements")
public class announcementController {
    
    private static Integer moduleId = 14;
    
    @Value("${programId}")
    private Integer programId;
    
    @Value("${topSecret}")
    private String topSecret;
    
    @Value("${programName}")
    private String programName; 
   
    private static boolean allowCreate = false;
    private static boolean allowEdit = false;
    private static boolean allowDelete = false;
    
    @Autowired
    private programManager programmanager;
    
    @Autowired
    private announcementManager announcementmanager;
    
    @Autowired
    private userManager usermanager;
    
    @Autowired
    private hierarchyManager hierarchymanager;
    
    /**
     * The '' request will display the list of active announcements.
     *
     * @param session
     * @return	the administrator dashboard view
     * @throws Exception
     */
    @RequestMapping(value = "", method = RequestMethod.GET)
    public ModelAndView listAnnouncements(HttpSession session) throws Exception {
        
        ModelAndView mav = new ModelAndView();
        mav.setViewName("/announcements");

        /* Get a list of completed surveys the logged in user has access to */
        User userDetails = (User) session.getAttribute("userDetails");
        
        /* Get list of announcements */
        List<announcement> announcements = announcementmanager.getAnnouncements(programId, userDetails);
        
        if(announcements != null && announcements.size() > 0) {
            for(announcement anncment:announcements) {
                if(anncment.getTotalDocuments() > 0) {
                    List<announcementDocuments> documents = announcementmanager.getAnnouncementDocuments(anncment.getId());
                    
                    if(documents != null && documents.size() > 0) {
                        for(announcementDocuments doc : documents) {
                            if(doc.getUploadedFile() != null && !"".equals(doc.getUploadedFile())) {
                                int index = doc.getUploadedFile().lastIndexOf('.');
                                doc.setFileExt(doc.getUploadedFile().substring(index+1));

                                if(doc.getUploadedFile().length() > 60) {
                                    String shortenedTitle = doc.getUploadedFile().substring(0,30) + "..." + doc.getUploadedFile().substring(doc.getUploadedFile().length()-10, doc.getUploadedFile().length());
                                    doc.setShortenedTitle(shortenedTitle);
                                }
                                doc.setEncodedTitle(URLEncoder.encode(doc.getUploadedFile(),"UTF-8"));
                            }
                        }
                        anncment.setDocuments(documents);
                    }
                }
            }
        }
        
        mav.addObject("announcements", announcements);
        
        /* Get user permissions */
        userProgramModules modulePermissions = usermanager.getUserModulePermissions(programId, userDetails.getId(), moduleId);
        if (userDetails.getRoleId() == 2) {
           allowCreate = true;
           allowEdit = true;
           allowDelete = true;
        } else {
           allowCreate = modulePermissions.isAllowCreate();
           allowEdit = modulePermissions.isAllowEdit();
           allowDelete = modulePermissions.isAllowDelete();
        }

        mav.addObject("allowCreate", allowCreate);
        mav.addObject("allowEdit", allowEdit);
        mav.addObject("allowDelete", allowDelete);
       
        return mav;
    }
    
    /**
     * The 'manage' request will display the list of announcements for an admin to manage.
     *
     * @param session
     * @return	the administrator dashboard view
     * @throws Exception
     */
    @RequestMapping(value = "manage", method = RequestMethod.GET)
    public ModelAndView manageAnnouncements(HttpSession session) throws Exception {
        
        ModelAndView mav = new ModelAndView();
        mav.setViewName("/manage");

        /* Get a list of completed surveys the logged in user has access to */
        User userDetails = (User) session.getAttribute("userDetails");
        
        /* Get list of announcements */
        List<announcement> announcements = announcementmanager.getAllAnnouncements(programId);
        
        if(announcements != null && announcements.size() > 0) {
            
            for(announcement anncment : announcements) {
                encryptObject encrypt = new encryptObject();
                Map<String,String> map;
                
                //Encrypt the use id to pass in the url
                map = new HashMap<String,String>();
                map.put("id",Integer.toString(anncment.getId()));
                map.put("topSecret",topSecret);

                String[] encrypted = encrypt.encryptObject(map);

                anncment.setEncryptedId(encrypted[0]);
                anncment.setEncryptedSecret(encrypted[1]);
            } 
        }
        
        mav.addObject("announcements", announcements);
        
        /* Get user permissions */
        userProgramModules modulePermissions = usermanager.getUserModulePermissions(programId, userDetails.getId(), moduleId);
        if (userDetails.getRoleId() == 2) {
           allowCreate = true;
           allowEdit = true;
           allowDelete = true;
        } else {
           allowCreate = modulePermissions.isAllowCreate();
           allowEdit = modulePermissions.isAllowEdit();
           allowDelete = modulePermissions.isAllowDelete();
        }

        mav.addObject("allowCreate", allowCreate);
        mav.addObject("allowEdit", allowEdit);
        mav.addObject("allowDelete", allowDelete);
        
        return mav;
    }
    
    
    /**
     * The '/details' GET request will display the selected staff member details page.
     * 
     * @param i The encrypted url value containing the selected user id
     * @param v The encrypted url value containing the secret decode key
     * @return
     * @throws Exception 
     */
    @RequestMapping(value = "/details", method = RequestMethod.GET)
    public ModelAndView getAnnouncementDetails(
             @RequestParam(value = "i", required = false) String i,
            @RequestParam(value = "v", required = false) String v,
            HttpSession session) throws Exception {
        
        ModelAndView mav = new ModelAndView();
        mav.setViewName("/details");
        announcement announcementDetails;
        
        if(i != null && !"".equals(i)) {
            /* Decrypt the url */
            decryptObject decrypt = new decryptObject();

            Object obj = decrypt.decryptObject(i, v);

            String[] result = obj.toString().split((","));

            int announcementId = Integer.parseInt(result[0].substring(4));
            
            announcementDetails = announcementmanager.getAnnouncementById(announcementId);
        
            List<announcementDocuments> documents = announcementmanager.getAnnouncementDocuments(announcementId);

            if(documents != null && documents.size() > 0) {
                for(announcementDocuments doc : documents) {
                    if(doc.getUploadedFile() != null && !"".equals(doc.getUploadedFile())) {
                        int index = doc.getUploadedFile().lastIndexOf('.');
                        doc.setFileExt(doc.getUploadedFile().substring(index+1));

                        if(doc.getUploadedFile().length() > 60) {
                            String shortenedTitle = doc.getUploadedFile().substring(0,30) + "..." + doc.getUploadedFile().substring(doc.getUploadedFile().length()-10, doc.getUploadedFile().length());
                            doc.setShortenedTitle(shortenedTitle);
                        }
                        doc.setEncodedTitle(URLEncoder.encode(doc.getUploadedFile(),"UTF-8"));
                    }
                }
            }
            
            List<announcementEntities> entities = announcementmanager.getEntities(programId, announcementId);
            
            if(entities != null && entities.size() > 0) {
                List<Integer> entityList = new ArrayList<Integer>();
                for(announcementEntities entity : entities) {
                    entityList.add(entity.getEntityId());
                }
                announcementDetails.setAnnouncementEntities(entityList);
            }
            
            mav.addObject("existingDocuments", documents);

        }
        else {
            announcementDetails = new announcement();
        }
           
        mav.addObject("announcementDetails", announcementDetails);
        mav.addObject("v", v);
        mav.addObject("announcementId", i);
        
        programOrgHierarchy topLevel = hierarchymanager.getProgramOrgHierarchyBydspPos(1, programId);

        List<programHierarchyDetails> counties = hierarchymanager.getProgramHierarchyItems(topLevel.getId(), 0);

        mav.addObject("countyList", counties);
        mav.addObject("topLevelName", topLevel.getName());
        
        return mav;
    }
    
    
    /**
     * The '/details' POST request will handle saving the new/updated document
     * message.
     *
     * @param documentDetails
     * @param postDocuments
     * @param redirectAttr
     * @param session
     * @param alertUsers
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/details", method = RequestMethod.POST)
    public @ResponseBody
    ModelAndView saveAnnouncementForm(
            @ModelAttribute(value = "announcementDetails") announcement announcementDetails,
            @RequestParam(value = "postDocuments", required = false) List<MultipartFile> postDocuments, 
            RedirectAttributes redirectAttr,
            @RequestParam(value = "alertUsers", required = false, defaultValue = "0") Integer alertUsers,
            @RequestParam(value = "selectedEntities", required = false) List<Integer> selectedEntities,
            HttpSession session
    ) throws Exception {

        /* Get a list of completed surveys the logged in user has access to */
        User userDetails = (User) session.getAttribute("userDetails");
        
        Integer initialannouncementId = announcementDetails.getId();
        
        /* Need to transfer String start and end date to real date */
        DateFormat format = new SimpleDateFormat("MM/dd/yyyy");
        
        if(!"".equals(announcementDetails.getActiveDate())) {
            Date realActivateDate = format.parse(announcementDetails.getActiveDate());
            announcementDetails.setActivateDate(realActivateDate);
        }
        else {
            announcementDetails.setActivateDate(null);
        }
        
        if(!"".equals(announcementDetails.getRetireDate())) {
            Date realRetirementDate = format.parse(announcementDetails.getRetireDate());
            announcementDetails.setRetirementDate(realRetirementDate);
        }
        else {
            announcementDetails.setRetirementDate(null);
        }
        
        announcementDetails.setProgramId(programId);
        announcementDetails.setSystemUserId(userDetails.getId());
        
        Integer announcementId = announcementmanager.saveAnnouncement(announcementDetails);
        
        if (postDocuments != null) {
            announcementmanager.saveUploadedDocument(announcementId, programId, postDocuments);
        }
        
        /* Remove existing entities */
        announcementmanager.removeEntities(programId, announcementId);
        
        /* Enter the selected counties */
        if (announcementDetails.getWhichEntity() == 1) {
            /* Need to get all top entities for the program */
            programOrgHierarchy topLevel = hierarchymanager.getProgramOrgHierarchyBydspPos(1, programId);
            List<programHierarchyDetails> entities = hierarchymanager.getProgramHierarchyItems(topLevel.getId(), 0);

            if (entities != null && entities.size() > 0) {
                for (programHierarchyDetails entity : entities) {
                    announcementEntities newentity = new announcementEntities();
                    newentity.setEntityId(entity.getId());
                    newentity.setProgramId(programId);
                    newentity.setAnnouncementId(announcementId);
                    
                    announcementmanager.saveEntities(newentity);
                }
            }
        } else if (announcementDetails.getWhichEntity() == 2 && selectedEntities != null && !"".equals(selectedEntities)) {
            for (Integer entity : selectedEntities) {
                announcementEntities newentity = new announcementEntities();
                newentity.setEntityId(entity);
                newentity.setProgramId(programId);
                newentity.setAnnouncementId(announcementId);
                
                announcementmanager.saveEntities(newentity);
            }
        }

        /* Alert Users, we only alert if new document and not private doc  */
        if(alertUsers > 0) {
            
            /* County Users */
            if(announcementDetails.getWhichEntity() == 2 ) { //new document
                announcementEmailNotifications emailNotification = new announcementEmailNotifications();
                emailNotification.setProgramId(programId);
                emailNotification.setNotificationType(1); //docs for user in hierarchy
                emailNotification.setAnnouncementId(announcementDetails.getId());
                announcementmanager.saveEmailNotification(emailNotification);
            }
            /* All Users, new document, not private */
            else {
                announcementEmailNotifications emailNotification = new announcementEmailNotifications();
                emailNotification.setProgramId(programId);
                if(announcementDetails.getIsAdminOnly()) {
                   emailNotification.setNotificationType(3); //docs for only admin users
                }
                else {
                   emailNotification.setNotificationType(2); //docs for user in hierarchy
                }
                emailNotification.setAnnouncementId(announcementDetails.getId());
                announcementmanager.saveEmailNotification(emailNotification);   
            }  
        }
        
        encryptObject encrypt = new encryptObject();
        Map<String, String> map;
        
        map = new HashMap<String, String>();
        map.put("id", Integer.toString(announcementId));
        map.put("topSecret", topSecret);

        String[] encrypted = encrypt.encryptObject(map);
        
       ModelAndView mav;
       if(initialannouncementId == 0) {
           redirectAttr.addFlashAttribute("savedStatus", "created");
       }
       else {
           redirectAttr.addFlashAttribute("savedStatus", "updated");
       }
       mav = new ModelAndView(new RedirectView("/announcements/details?i=" + encrypted[0] + "&v=" + encrypted[1]));
       
       return mav;

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
        
        announcementDocuments documentDetails = announcementmanager.getDocumentById(documentId);
        documentDetails.setStatus(false);
        announcementmanager.saveDocumentFile(documentDetails);
        return 1;
    }
    
    /* The 'saveDspOrder.do' POST request will remove the clicked uploaded
     * document.
     *
     * @param documentId The id of the clicked document.
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/saveDspOrder.do", method = RequestMethod.POST)
    public @ResponseBody
    Integer saveDspOrder(
            @RequestParam(value = "announcementId", required = true) Integer announcementId,
            @RequestParam(value = "dspVal", required = true) Integer dspVal
            ) throws Exception {
        
        
        announcement announcementDetails = announcementmanager.getAnnouncementById(announcementId);
        
        if(dspVal > 0) {
            announcementDetails.setDspOrder(dspVal);
            announcementmanager.saveAnnouncement(announcementDetails);
        }
        
        return 1;
    }
    
    /**
     * The '/delete' GET request will handle deleting the selected announcement
     * message.
     *
     * @param i The encrypted url value containing the selected user id
     * @param v The encrypted url value containing the secret decode key
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/delete", method = RequestMethod.GET)
    public ModelAndView deleteAnnouncement(
             @RequestParam(value = "i", required = false) String i,
            @RequestParam(value = "v", required = false) String v,
            RedirectAttributes redirectAttr,
            HttpSession session) throws Exception {
        
        
        
        if(i != null && !"".equals(i)) {
            /* Decrypt the url */
            decryptObject decrypt = new decryptObject();

            Object obj = decrypt.decryptObject(i, v);

            String[] result = obj.toString().split((","));

            int announcementId = Integer.parseInt(result[0].substring(4));
            
           announcementmanager.deleteAnnouncement(announcementId);
        
            List<announcementDocuments> documents = announcementmanager.getAnnouncementDocuments(announcementId);

            if(documents != null && documents.size() > 0) {
                //Set the directory to save the brochures to
                fileSystem dir = new fileSystem();
                dir.setDir(programName, "announcementUploadedFiles");
                
                for(announcementDocuments doc : documents) {
                    File newFile = new File(dir.getDir() + doc.getUploadedFile());

                    if (newFile.exists()) {
                        newFile.delete();
                    } 
                }
                announcementmanager.deleteAnnouncementDocuments(announcementId);
            }
        }
       
       ModelAndView mav;
       redirectAttr.addFlashAttribute("savedStatus", "deleted");
       mav = new ModelAndView(new RedirectView("/announcements/manage"));
       
       return mav;
    }
    
    /**
     * The 'getAnnouncementNotificationModel' GET request will display the announcement notification modal.
     * @param session
     * @param request
     * @return
     * @throws Exception 
     */
    @RequestMapping(value = "/getAnnouncementNotificationModel.do", method = RequestMethod.GET)
    public ModelAndView getAnnouncementNotificationModel(HttpSession session, HttpServletRequest request) throws Exception {

        ModelAndView mav = new ModelAndView();
        mav.setViewName("/announcements/announcementNotificationPreferences");

        User userDetails = (User) session.getAttribute("userDetails");

        announcementNotificationPreferences notificationPreferences = announcementmanager.getNotificationPreferences(userDetails.getId());

        if (notificationPreferences != null) {
            mav.addObject("notificationPreferences", notificationPreferences);
        } else {
            announcementNotificationPreferences newNotificationPreferences = new announcementNotificationPreferences();
            newNotificationPreferences.setNotificationEmail(userDetails.getEmail());
            newNotificationPreferences.setProgramId(programId);
            mav.addObject("notificationPreferences", newNotificationPreferences);
        }
        
        return mav;
    }
    
    /**
     * 
     * @param notificationPreferences
     * @param errors
     * @param session
     * @param request
     * @return
     * @throws Exception 
     */
    @RequestMapping(value = "/saveNotificationPreferences.do", method = RequestMethod.POST)
    public @ResponseBody
    Integer saveNotificationPreferences(@ModelAttribute(value = "notificationPreferences") announcementNotificationPreferences notificationPreferences, BindingResult errors,
            HttpSession session, HttpServletRequest request) throws Exception {
        
        User userDetails = (User) session.getAttribute("userDetails");

        notificationPreferences.setSystemUserId(userDetails.getId());

        announcementmanager.saveNotificationPreferences(notificationPreferences);

        return 1;

    }
    
}
