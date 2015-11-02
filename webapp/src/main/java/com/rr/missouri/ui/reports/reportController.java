/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.rr.missouri.ui.reports;

import com.registryKit.hierarchy.hierarchyManager;
import com.registryKit.hierarchy.programHierarchyDetails;
import com.registryKit.hierarchy.programOrgHierarchy;
import com.registryKit.report.reportManager;
import com.registryKit.report.reportRequestDisplay;
import com.registryKit.survey.surveys;
import com.registryKit.user.User;
import com.registryKit.user.userManager;
import com.registryKit.user.userProgramModules;
import com.rr.missouri.ui.security.encryptObject;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

/**
 *
 * @author chadmccue
 */
@Controller
@RequestMapping("/reports")
public class reportController {
    
   private static Integer moduleId = 3;
   
   @Autowired
   private hierarchyManager hierarchymanager;
   
   @Autowired
   private userManager usermanager;
   
   @Autowired
   private reportManager reportmanager;
   
   private static boolean allowCreate = false;
   private static boolean allowEdit = false;
   
    
   @Value("${programId}")
   private Integer programId;
   
   @Value("${topSecret}")
   private String topSecret;
   
    @RequestMapping(value = "", method = {RequestMethod.POST, RequestMethod.GET})
    public ModelAndView listReports(HttpSession session) throws Exception {
       
    	User userDetails = (User) session.getAttribute("userDetails");
    	
        ModelAndView mav = new ModelAndView();
        
        /* Get user permissions */
        userProgramModules modulePermissions = usermanager.getUserModulePermissions(programId, userDetails.getId(), moduleId);
        if (userDetails.getRoleId() == 2) {
            allowCreate = true;
            allowEdit = true;
        } else {
            allowCreate = modulePermissions.isAllowCreate();
            allowEdit = modulePermissions.isAllowEdit();
        }

        mav.addObject("allowCreate", allowCreate);
        mav.addObject("allowEdit", allowEdit);
        
        encryptObject encrypt = new encryptObject();
        Map<String, String> map;
        
        List <reportRequestDisplay> reportRequestList =  reportmanager.getReportRequests(programId, userDetails);
        for (reportRequestDisplay rr : reportRequestList) {
            //Encrypt the use id to pass in the url
            map = new HashMap<String, String>();
            map.put("id", Integer.toString(rr.getId()));
            map.put("topSecret", topSecret);

            String[] encrypted = encrypt.encryptObject(map);
            rr.setEncryptedId(encrypted[0]);
            rr.setEncryptedSecret(encrypted[1]);
        }
        
        
        mav.addObject("reportRequestList", reportRequestList);
        mav.setViewName("/list");
        return mav;
    }
   
    @RequestMapping(value = "/request", method = RequestMethod.GET)
    public ModelAndView adHocReports(HttpSession session) throws Exception {
       
        ModelAndView mav = new ModelAndView();
        mav.setViewName("/request");
        
        User userDetails = (User) session.getAttribute("userDetails");
        
        List<programOrgHierarchy> orgHierarchyList = hierarchymanager.getProgramOrgHierarchy(programId);
        
        //entity 1 items
        for(programOrgHierarchy hierarchy : orgHierarchyList) {
            if (userDetails.getRoleId() != 3) {
            		List<programHierarchyDetails> hierarchyItems = hierarchymanager.getProgramHierarchyItems(hierarchy.getId());
                    hierarchy.setProgramHierarchyDetails(hierarchyItems);	
                } else {
            		List<programHierarchyDetails> hierarchyItems = hierarchymanager.getProgramHierarchyItems(hierarchy.getId(), userDetails.getId());
                    hierarchy.setProgramHierarchyDetails(hierarchyItems);
                }
        }
        
        mav.addObject("entity1List", orgHierarchyList.get(0).getProgramHierarchyDetails());
        mav.addObject("entity2List", orgHierarchyList.get(1).getProgramHierarchyDetails());
        mav.addObject("entity3List", orgHierarchyList.get(2).getProgramHierarchyDetails());
        
        return mav;
    }

    
    
    
}
