/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.rr.missouri.ui.users;

import com.registryKit.announcements.announcementManager;
import com.registryKit.announcements.announcementNotificationPreferences;
import com.registryKit.calendar.calendarManager;
import com.registryKit.calendar.calendarNotificationPreferences;
import com.registryKit.document.documentManager;
import com.registryKit.document.documentNotificationPreferences;
import com.registryKit.forum.forumManager;
import com.registryKit.forum.forumNotificationPreferences;
import com.registryKit.hierarchy.hierarchyManager;
import com.registryKit.hierarchy.programHierarchyDetails;
import com.registryKit.hierarchy.programOrgHierarchy;
import com.registryKit.hierarchy.userProgramHierarchy;
import com.registryKit.program.programManager;
import com.registryKit.program.programModules;
import com.registryKit.user.User;
import com.registryKit.user.userManager;
import com.registryKit.user.userProgramModules;
import com.registryKit.user.userPrograms;
import com.rr.missouri.ui.security.decryptObject;
import com.rr.missouri.ui.security.encryptObject;
import java.net.URLDecoder;
import java.net.URLEncoder;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Objects;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.validation.Valid;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.validation.BindingResult;
import org.springframework.validation.ObjectError;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import org.springframework.web.servlet.view.RedirectView;

/**
 *
 * @author chadmccue
 */
@Controller
@RequestMapping("/users")
public class userController {
    
    private static Integer moduleId = 12;
    
    @Autowired
    private hierarchyManager hierarchymanager;
    
    @Autowired
    private programManager programmanager;
    
    @Autowired
    private userManager usermanager;
    
    @Autowired
    private calendarManager calmanager;
    
    @Autowired
    private forumManager forummanager;
    
    @Autowired
    private documentManager documentmanager;
    
    @Autowired
    private announcementManager announcementmanager;
    
    @Value("${programId}")
    private Integer programId;
    
    @Value("${topSecret}")
    private String topSecret;
    
    private static boolean allowCreate = false;
    private static boolean allowEdit = false;
    private static boolean allowDelete = false;
    
    /**
     * The '' request will display the list of program users.
     *
     * @param request
     * @param response
     * @return	the client engagement list view
     * @throws Exception
     */
    @RequestMapping(value = "", method = RequestMethod.GET)
    public ModelAndView listUsers(HttpSession session) throws Exception {
        
        ModelAndView mav = new ModelAndView();
        mav.setViewName("/users");
        
        /* Get a list of completed surveys the logged in user has access to */
        User userDetails = (User) session.getAttribute("userDetails");
        
        List<User> programUsers = null;
        
        /* Get the entity level 3 available for the logged in user */
        if (userDetails.getRoleId() != 2) {
            programOrgHierarchy level3 = hierarchymanager.getProgramOrgHierarchyBydspPos(3, programId);
            List<programHierarchyDetails> level3Items = hierarchymanager.getProgramHierarchyItems(level3.getId(), userDetails.getId());
        
            /* Get the program users */
            programUsers = usermanager.getUsersByProgramId(programId, level3.getId(), level3Items, userDetails.getId());
        }
        else {
            programUsers = usermanager.getUsersByProgramId(programId, 0, null, userDetails.getId());
        }
        
        if(programUsers != null && !programUsers.isEmpty()) {
            
            encryptObject encrypt = new encryptObject();
            Map<String,String> map;
            
            for(User user : programUsers) {
                
                //Encrypt the use id to pass in the url
                map = new HashMap<String,String>();
                map.put("id",Integer.toString(user.getId()));
                map.put("topSecret",topSecret);

                String[] encrypted = encrypt.encryptObject(map);

                user.setEncryptedId(encrypted[0]);
                user.setEncryptedSecret(encrypted[1]);
                
                User createdByDetails = usermanager.getUserById(user.getCreatedBy());
                user.setCreatedByName(createdByDetails.getFirstName()+" "+createdByDetails.getLastName());
            }
        }
       
        mav.addObject("programUsers", programUsers);
        
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
     * The '/user.create' GET request will be used to create a new program staff member
     *
     * @return The blank staff member page
     *
     * @Objects (1) An object that will hold the blank program admin form.
     */
    @RequestMapping(value = "/user.create", method = RequestMethod.GET)
    @ResponseBody public ModelAndView newUserForm(HttpSession session) throws Exception {
        ModelAndView mav = new ModelAndView();
        mav.setViewName("/users/newUser");

        //Create a new blank staff member.
        User user = new User();
        
        mav.addObject("userDetails", user);
        
        return mav;
    }
    
     /**
     * The '/user.create' POST request will handle submitting the new staff member.
     *
     * @param userDetails    The object containing the user form fields
     * @param result          The validation result
     * @param redirectAttr    The variable that will hold values that can be read after the redirect
     *
     * @return	Will send the program admin to the details of the new staff member
     
     * @throws Exception
     */
    @RequestMapping(value = "/user.create", method = RequestMethod.POST)
    public @ResponseBody ModelAndView saveStaffMember(@Valid @ModelAttribute(value = "userDetails") User newuserDetails, BindingResult result, HttpSession session) throws Exception {

        if (result.hasErrors()) {
            
            for(ObjectError error : result.getAllErrors()) {
                System.out.println("Error: " + error.getDefaultMessage());
            }
            
            ModelAndView mav = new ModelAndView();
            mav.setViewName("/users/newUser");
            return mav;
        }
        
        /* Check for duplicate email address */
        User existingUser = usermanager.checkDuplicateUsername(newuserDetails.getUsername(), programId, 0);
        
        if (existingUser != null ) {
            ModelAndView mav = new ModelAndView();
            mav.setViewName("/users/newUser");
            mav.addObject("existingUser", "The username is already being used by another user.");
            return mav;
        }
          
            
        /* Get a list of completed surveys the logged in user has access to */
        User userDetails = (User) session.getAttribute("userDetails");
        
        newuserDetails.setCreatedBy(userDetails.getId());
        newuserDetails.setRoleId(3);
        
        newuserDetails = usermanager.encryptPW(newuserDetails);
        Integer userId = usermanager.createUser(newuserDetails);
        
        /* associate user to program */
        userPrograms program = new userPrograms();
        program.setProgramId(programId);
        program.setsystemUserId(userId);
        programmanager.saveUserProgram(program);
        
        /* Opt in calendar notification preferences */
        calendarNotificationPreferences calPreferences = new calendarNotificationPreferences();
        calPreferences.setSystemUserId(userId);
        calPreferences.setNotificationEmail(newuserDetails.getEmail());
        calPreferences.setModifyEventNotifications(true);
        calPreferences.setNewEventNotifications(true);
        calPreferences.setProgramId(programId);
        
        calmanager.saveNotificationPreferences(calPreferences);
        
        /* Opt in forum notification preferences */
        forumNotificationPreferences forumPreferences = new forumNotificationPreferences();
        forumPreferences.setSystemUserId(userId);
        forumPreferences.setNotificationEmail(newuserDetails.getEmail());
        forumPreferences.setNewTopicsNotifications(true);
        forumPreferences.setRepliesTopicsNotifications(true);
        forumPreferences.setMyPostsNotifications(true);
        forumPreferences.setProgramId(programId);
        
        forummanager.saveNotificationPreferences(forumPreferences);
        
        /* Opt in document notification preferences */
        documentNotificationPreferences documentPreferences = new documentNotificationPreferences();
        documentPreferences.setAllDocs(true);
        documentPreferences.setProgramId(programId);
        documentPreferences.setNotificationEmail(newuserDetails.getEmail());
        documentPreferences.setSystemUserId(userId);
        documentPreferences.setMyHierarchiesOnly(true);
        
        documentmanager.saveNotificationPreferences(documentPreferences);
        
        /* Opt in announcement notification preferences */
        announcementNotificationPreferences announcementPreferences = new announcementNotificationPreferences();
        announcementPreferences.setAllAnnouncements(true);
        announcementPreferences.setProgramId(programId);
        announcementPreferences.setNotificationEmail(newuserDetails.getEmail());
        announcementPreferences.setSystemUserId(userId);
        announcementPreferences.setMyHierarchiesOnly(true);
        
        announcementmanager.saveNotificationPreferences(announcementPreferences);
        
        Map<String,String> map = new HashMap<String,String>();
        map.put("id",Integer.toString(userId));
        map.put("topSecret",topSecret);
        
        encryptObject encrypt = new encryptObject();

        String[] encrypted = encrypt.encryptObject(map);
        
        ModelAndView mav = new ModelAndView();
        mav.setViewName("/users/newUser");
        mav.addObject("encryptedURL", "?i="+encrypted[0]+"&v="+encrypted[1]);
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
    public ModelAndView getUserDetails(@RequestParam String i, @RequestParam String v, HttpSession session) throws Exception {
        
        /* Decrypt the url */
        decryptObject decrypt = new decryptObject();
        
        Object obj = decrypt.decryptObject(i, v);
        
        String[] result = obj.toString().split((","));
        
        int userId = Integer.parseInt(result[0].substring(4));
        
        User userDetais = usermanager.getUserById(userId);
        
        ModelAndView mav = new ModelAndView();
        mav.setViewName("/userDetails");
        mav.addObject("userDetais", userDetais);
        mav.addObject("v", v);
        mav.addObject("userId", i);
        
        return mav;
    }
    
    /**
     * The '/details' POST request will submit the staff member changes once all required fields are checked, the system will also check to make sure the users email address is not already in use.
     *
     * @param staffdetails	The object holding the staff member form fields
     * @param result            The validation result
     * @param redirectAttr	The variable that will hold values that can be read after the redirect
     * @param action            The variable that holds which button was pressed
     * @param userId            The encrypted value of the staff member being updated
     * @param v                 The encrypted secret
     *
     * @return	Will return the staff member list page on "Save & Close" Will return the staff member details page on "Save" Will return the staff member create page on error
     * @throws Exception
     * janice.watson@bhmh.org
     */
    @RequestMapping(value = "/details", method = RequestMethod.POST)
    public ModelAndView updateStaffDetails(@Valid @ModelAttribute(value = "userDetais") User userDetais, BindingResult result, 
            RedirectAttributes redirectAttr, 
            @RequestParam String i, 
            @RequestParam String v, 
            HttpSession session,
            HttpServletResponse response) throws Exception {
            
        /* Decrypt the url */
        decryptObject decrypt = new decryptObject();
        
        Object obj = decrypt.decryptObject(i, v);
        
        String[] decryptResult = obj.toString().split((","));
        
        int readableUserId = Integer.parseInt(decryptResult[0].substring(4));
        
        userDetais.setId(readableUserId);
        
        if (result.hasErrors()) {
            ModelAndView mav = new ModelAndView();
            mav.setViewName("/userDetails");
            return mav;
        }
        
        /* Check for duplicate email address */
        User existingUser = usermanager.checkDuplicateUsername(userDetais.getUsername(), programId, readableUserId);
        if (existingUser != null && existingUser.getId() != readableUserId) {
            ModelAndView mav = new ModelAndView();
            mav.setViewName("/userDetails");
            mav.addObject("existingUser", "The username is already being used by another user.");

            return mav;
        }
        
        if (!userDetais.getPassword().equalsIgnoreCase("")) {
        	userDetais = usermanager.encryptPW(userDetais);
        } else {
        	User currentUser = usermanager.getUserById(userDetais.getId());
        	userDetais.setEncryptedPw(currentUser.getEncryptedPw());
        	userDetais.setRandomSalt(currentUser.getRandomSalt());
        }
        usermanager.updateUser(userDetais);
        
        redirectAttr.addFlashAttribute("savedStatus", "updated");
        ModelAndView mav = new ModelAndView(new RedirectView("/users/details?i="+URLEncoder.encode(i,"UTF-8")+"&v="+URLEncoder.encode(v,"UTF-8")));
        return mav;
    }
    
    /**
     * The 'getAssociatedPrograms' GET request will return a list of programs the user is associated with.
     * 
     * @param i The encrypted userId
     * @param v The encrypted secret
     * @return  This function will return the associated programs view.
     * @throws Exception 
     */
    @RequestMapping(value = "/getAssociatedPrograms.do", method = RequestMethod.GET)
    public @ResponseBody ModelAndView getAssociatedPrograms(@RequestParam String i, @RequestParam String v, HttpSession session) throws Exception {
        
        /* Decrypt the url */
        int userId = decryptURLParam(i,v);
        
        /* Get associated programs */
        List<userPrograms> programs = usermanager.getUserPrograms(userId);
        
        ModelAndView mav = new ModelAndView();
        mav.setViewName("/users/associatedPrograms");
        mav.addObject("programs", programs);
        
        /* Get a list of completed surveys the logged in user has access to */
        User userDetails = (User) session.getAttribute("userDetails");
        
        /* Get the top level entity */
        programOrgHierarchy topLevelEntity = hierarchymanager.getProgramOrgHierarchyBydspPos(1, programId);
        mav.addObject("topEntity", topLevelEntity.getName());
        
        return mav;
        
    }
    
    /**
     * The 'decryptURLParam' will take the encryptd url parameters and return the userid as an integer.
     * 
     * @param i The encrypted userId
     * @param v The encrypted secret.
     * @return  This function will return the decrypted userid.
     * @throws Exception 
     */
    public int decryptURLParam(@RequestParam String i, @RequestParam String v) throws Exception {
        
        /* Decrypt the url */
        decryptObject decrypt = new decryptObject();
        
        Object obj = decrypt.decryptObject(URLDecoder.decode(i, "UTF-8"), URLDecoder.decode(v, "UTF-8"));
        
        String[] result = obj.toString().split((","));
        
        int userId = Integer.parseInt(result[0].substring(4));
        
        return userId;
    }
    
    /**
     * The 'getProgramModules' GET request will return a list of modules associated to the program and check to see if the user has access to the module.
     * 
     * @param i The encrypted userId
     * @param v The encrypted secret
     * @return  This function will return the program module model
     * @throws Exception 
     */
    @RequestMapping(value = "/getProgramModules.do", method = RequestMethod.GET)
    public @ResponseBody ModelAndView getProgramModules(@RequestParam String i, @RequestParam String v, HttpSession session) throws Exception {
        
        /* Decrypt the url */
        int userId = decryptURLParam(i,v);
        
        User userDetails = usermanager.getUserById(userId);
        
        /* Get a list of modules for the program */
        List<programModules> modules = programmanager.getUsedModulesByProgram(programId);
        
        /* Get a list of modules for the user */
        List<userProgramModules> userModules = usermanager.getUsedModulesByUser(programId, userId, userDetails.getRoleId());
        
        if(!userModules.isEmpty()) {
            for(userProgramModules usermodule : userModules) {
                for(programModules module : modules) {
                    if(Objects.equals(module.getModuleId(), usermodule.getModuleId())) {
                        
                        userProgramModules modulePermissions = usermanager.getUserModulePermissions(programId, userDetails.getId(), module.getModuleId());
                        
                        module.setUseModule(true);
                        module.setAllowCreate(modulePermissions.isAllowCreate());
                        module.setAllowDelete(modulePermissions.isAllowDelete());
                        module.setAllowEdit(modulePermissions.isAllowEdit());
                        module.setAllowExport(modulePermissions.isAllowExport());
                        module.setAllowImport(modulePermissions.isAllowImport());
                        module.setAllowLevel1(modulePermissions.isAllowLevel1());
                        module.setAllowLevel2(modulePermissions.isAllowLevel2());
                        module.setAllowLevel3(modulePermissions.isAllowLevel3());
                        module.setAllowReconcile(modulePermissions.isAllowReconcile());
                    }
                }
            }
        }
       
        ModelAndView mav = new ModelAndView();
        mav.setViewName("/users/programModules");
        mav.addObject("userId", i);
        mav.addObject("v", v);
        mav.addObject("programModules", modules);
        
        return mav;
    }
    
    /**
     * The 'saveProgramUserModules' POST request will submit the selected program modules for the user and program.
     * 
     * @param i The encrypted userId
     * @param v The encrypted secret
     * @param modules   The selected program modules.
     * @return
     * @throws Exception 
     */
    @RequestMapping(value = "/saveProgramUserModules.do", method = RequestMethod.POST)
    public @ResponseBody ModelAndView saveProgramUserModules(@RequestParam String i, @RequestParam String v, HttpSession session, HttpServletRequest request) throws Exception {
        
        /* Decrypt the url */
        int userId = decryptURLParam(i,v);
                 
        /* Clear out current user modules */
        usermanager.removeUsedModulesByUser(programId, userId);
        
        ArrayList programModuleList = new ArrayList(Arrays.asList(request.getParameter("selProgramModules").split(",")));
        
        if(!programModuleList.isEmpty()) {
             
            for (Object programModuleList1 : programModuleList) {
                Integer module = Integer.parseInt(programModuleList1.toString());
                userProgramModules userModule = new userProgramModules();
                userModule.setSystemUserId(userId);
                userModule.setProgramId(programId);
                userModule.setModuleId(module);
                if(request.getParameter("create_"+module) != null) {
                    userModule.setAllowCreate(true);
                }
                if(request.getParameter("edit_"+module) != null) {
                    userModule.setAllowEdit(true);
                }
                if(request.getParameter("delete_"+module) != null) {
                    userModule.setAllowDelete(true);
                }
                if(request.getParameter("level1_"+module) != null) {
                    userModule.setAllowLevel1(true);
                }
                if(request.getParameter("level2_"+module) != null) {
                    userModule.setAllowLevel2(true);
                }
                if(request.getParameter("level3_"+module) != null) {
                    userModule.setAllowLevel3(true);
                }
                if(request.getParameter("reconcile_"+module) != null) {
                    userModule.setAllowReconcile(true);
                }
                if(request.getParameter("import_"+module) != null) {
                    userModule.setAllowImport(true);
                }
                if(request.getParameter("export_"+module) != null) {
                    userModule.setAllowExport(true);
                }
                usermanager.saveUsedModulesByUser(userModule);
            }
        }
        
        ModelAndView mav = new ModelAndView();
        mav.setViewName("/users/programModules");
        mav.addObject("encryptedURL", "?i="+i+"&v="+v);
        
        return mav;
    }
    
    
    /**
     * The 'getProgramEntities.do' GET request will return a list of departments associated to the program and the user.
     * 
     * @param i The encrypted userId
     * @param v The encrypted secret
     * @param programId The clicked program
     * @return  This function will return the program department model
     * @throws Exception 
     */
    @RequestMapping(value = "/getProgramEntities.do", method = RequestMethod.GET)
    public @ResponseBody ModelAndView getProgramEntities(@RequestParam String i, @RequestParam String v, HttpSession session) throws Exception {
        
        ModelAndView mav = new ModelAndView();
        mav.setViewName("/users/programEntities");
        mav.addObject("userId", i);
        mav.addObject("v", v);
        mav.addObject("programId", programId);
        
        /* Decrypt the url */
        int userId = decryptURLParam(i,v);
        
        List<programOrgHierarchy> programEntities = hierarchymanager.getProgramOrgHierarchy(programId);
        Integer entityId = programEntities.get(0).getId();
        
        programOrgHierarchy entityDetails = hierarchymanager.getOrgHierarchyById(entityId);
        mav.addObject("heading", entityDetails.getName());
        mav.addObject("entityId", entityId);
        
        if(entityDetails.getDspPos() < programEntities.size()) {
            Integer nextDspPos = entityDetails.getDspPos()+1;
            programOrgHierarchy nextEntity = hierarchymanager.getProgramOrgHierarchyBydspPos(nextDspPos, programId);
            mav.addObject("nextEntityId", nextEntity.getId());
            mav.addObject("nextEntityName", nextEntity.getName());
        }
        
        /* Get a list of selected entites for the user */
        List<userProgramHierarchy> userSelectedEntities = hierarchymanager.getUserAssociatedEntities(programId, userId, entityId);
        List<Integer> userEntityItems = new ArrayList<Integer>();
        
        if(userSelectedEntities != null && userSelectedEntities.size() > 0) {
            for(userProgramHierarchy entity : userSelectedEntities) {
                Integer itemId = entity.getOrgHierarchyDetailId();
                userEntityItems.add(itemId);
            }
        }
        
        mav.addObject("userEntityItems", userEntityItems);
        
        /* Get a list of completed surveys the logged in user has access to */
        User userDetails = (User) session.getAttribute("userDetails");
        
        Integer loggeduserId = 0;
        if (userDetails.getRoleId() != 2) {
            loggeduserId = userDetails.getId();
        }
        
        /* Get a list of entity items for the selected entity */
        List<programHierarchyDetails> entityItems = hierarchymanager.getProgramHierarchyItemsActiveOnly(entityId,loggeduserId);
        mav.addObject("entityItems", entityItems);
        
        return mav;
        
    }
    
    /**
     * The 'saveProgramUserEntity.do' POST request will submit the selected program for the user.
     * 
     * @param i The encrypted userId
     * @param v The encrypted secret
     * @param modules   The selected program modules.
     * @return
     * @throws Exception 
     */
    @RequestMapping(value = "/saveProgramUserEntity.do", method = RequestMethod.POST)
    public @ResponseBody ModelAndView saveProgramUserEntity(@RequestParam String i, @RequestParam String v, @RequestParam Integer nextEntityId, @RequestParam Integer entityId,
            @RequestParam List<Integer> selectedEntityItems, HttpSession session) throws Exception {
        
        ModelAndView mav = new ModelAndView();
        mav.setViewName("/users/programEntities");
        mav.addObject("encryptedURL", "?i="+i+"&v="+v);
        mav.addObject("userId", i);
        mav.addObject("v", v);
        
        /* Decrypt the url */
        int userId = decryptURLParam(i,v);
        
        User userDetails = (User) session.getAttribute("userDetails");
        
        if(!selectedEntityItems.isEmpty()) {
            
            hierarchymanager.removeUserProgramHierarchy(entityId, userId);
            
            for(Integer hierarchyValue : selectedEntityItems) {
                userProgramHierarchy hierarchy = new userProgramHierarchy();
                hierarchy.setProgramId(programId);
                hierarchy.setSystemUserId(userId);
                hierarchy.setProgramHierarchyId(entityId);
                hierarchy.setOrgHierarchyDetailId(hierarchyValue);

                hierarchymanager.saveUserProgramHierarchy(hierarchy);
                
            }
        }
        
        if(nextEntityId != null && nextEntityId > 0) {
            List<programOrgHierarchy> programEntities = hierarchymanager.getProgramOrgHierarchy(programId);
            
            programOrgHierarchy entityDetails = hierarchymanager.getOrgHierarchyById(nextEntityId);
            mav.addObject("heading", entityDetails.getName());
            mav.addObject("entityId", nextEntityId);
            
            if(entityDetails.getDspPos() < programEntities.size()) {
                Integer nextDspPos = entityDetails.getDspPos()+1;
                programOrgHierarchy nextEntity = hierarchymanager.getProgramOrgHierarchyBydspPos(nextDspPos, programId);
                mav.addObject("nextEntityId", nextEntity.getId());
                mav.addObject("nextEntityName", nextEntity.getName());
            }
            
            /* Get a list of selected entites for the user */
            List<userProgramHierarchy> userSelectedEntities = hierarchymanager.getUserAssociatedEntities(programId, userId, nextEntityId);
            List<Integer> userEntityItems = new ArrayList<Integer>();

            if(userSelectedEntities != null && userSelectedEntities.size() > 0) {
                for(userProgramHierarchy entity : userSelectedEntities) {
                    Integer itemId = entity.getOrgHierarchyDetailId();
                    userEntityItems.add(itemId);
                }
            }

            mav.addObject("userEntityItems", userEntityItems);

            /* Get a list of entity items for the selected entity */
            List<programHierarchyDetails> entityItems = new ArrayList<programHierarchyDetails>();
            
            if(!selectedEntityItems.isEmpty()) {
                
                int loggedInuserId = 0;
                
                if(userDetails.getRoleId() != 2) {
                    loggedInuserId = userDetails.getId();
                }
                
                for(Integer hierarchyValue : selectedEntityItems) {
                     List<programHierarchyDetails> selEntityItems = hierarchymanager.getProgramHierarchyItemsByAssoc(nextEntityId, hierarchyValue,  loggedInuserId);
                    
                     if(selEntityItems != null && selEntityItems.size() > 0) {
                         for(programHierarchyDetails entity : selEntityItems) {
                             if(entity.isStatus()) {
                                entityItems.add(entity);
                             }
                         }
                     }
                }
            }
            
            mav.addObject("entityItems", entityItems);
        }
        else {
            mav.addObject("completed", 1);
        }
        
        return mav;
    }
}
