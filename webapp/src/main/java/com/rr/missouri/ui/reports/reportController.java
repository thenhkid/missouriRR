/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.rr.missouri.ui.reports;

import com.registryKit.hierarchy.hierarchyManager;
import com.registryKit.hierarchy.programHierarchyDetails;
import com.registryKit.hierarchy.programOrgHierarchy;
import com.registryKit.report.reportDetails;
import com.registryKit.report.reportManager;
import com.registryKit.report.reportRequest;
import com.registryKit.report.reportRequestDisplay;
import com.registryKit.report.reportType;
import com.registryKit.user.User;
import com.registryKit.user.userManager;
import com.registryKit.user.userProgramModules;
import com.rr.missouri.ui.security.encryptObject;

import java.util.Arrays;
import java.util.Date;
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
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.view.RedirectView;

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
    public ModelAndView reportRequests(HttpSession session) throws Exception {
       
        ModelAndView mav = new ModelAndView();
        mav.setViewName("/request");
        
        //this returns the report type list for this program
        List<reportType> reportTypeList = reportmanager. getReportTypes(programId, false);
        mav.addObject("reportTypes", reportTypeList);
        
        //these are the surveys, but should be populated with /availableReports.do
        List<reportDetails> reportList = reportmanager.getReportsForType(programId, false, 1);
        mav.addObject("reportList", reportList);
        
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
        
        //codeId list depends on selection criteria
        
        
        
        return mav;
    }

    
    //this returns available reports for selected type
    @RequestMapping(value = "/availableReports.do", method = RequestMethod.POST)
    public @ResponseBody
    ModelAndView returnReportDetails(HttpSession session,
            @RequestParam(value = "reportTypeId", required = false) Integer reportTypeId         
    )
            throws Exception {
    	
    	List <reportDetails> availableReports = reportmanager.getReportsForType(programId, false, reportTypeId);
    	//this ideally will just overwrite the current select box
        ModelAndView mav = new ModelAndView();
        //mav.setViewName("/reports/optionList.jsp");
        mav.addObject("availableReports", availableReports);
        return mav;
     }
    
    
    
    //this returns entities 2 & 3
    @RequestMapping(value = "/returnEntityList.do", method = RequestMethod.POST)
    public @ResponseBody
    ModelAndView changeDisplayPosList(HttpSession session,
            @RequestParam(value = "entityIds", required = true) List <Integer> entityIds,
            @RequestParam(value = "tier", required = true) Integer tier
    )
            throws Exception {
    	
    	entityIds = Arrays.asList(37,38,39);
    	tier = 2;
    	
    	
    	User userDetails = (User) session.getAttribute("userDetails");
        
        List<programOrgHierarchy> orgHierarchyList = hierarchymanager.getProgramOrgHierarchy(programId);
        List<programHierarchyDetails> hierarchyItems = null;
        //look up all the entity2Ids for entity1Ids for user who has permission
    	if (userDetails.getRoleId() != 3) { 
    		hierarchyItems = hierarchymanager.getProgramHierarchyItemsByAssocList(orgHierarchyList.get(tier-1).getId(), entityIds, 0);
        } else {
    		hierarchyItems = hierarchymanager.getProgramHierarchyItemsByAssocList(orgHierarchyList.get(tier-1).getId(), entityIds, userDetails.getId());
        }
    	
        ModelAndView mav = new ModelAndView();
        mav.setViewName("/reports/optionList.jsp");
        mav.addObject("selectText", "Districts");
        mav.addObject("listValues", hierarchyItems);
        return mav;
     }
    
    //narrows down code list by report
  //this returns entities 2 & 3
    @RequestMapping(value = "/getCodeList.do", method = RequestMethod.POST)
    public @ResponseBody
    ModelAndView getCodeList(HttpSession session,
            @RequestParam(value = "startDate", required = true) String startDate,
            @RequestParam(value = "endDate", required = true) String endDate,
            @RequestParam(value = "entities", required = true) String entityIds,
            @RequestParam(value = "reportIds", required = true) String reportIds
    )
            throws Exception {
    	
    	User userDetails = (User) session.getAttribute("userDetails");
        
        
        ModelAndView mav = new ModelAndView();
        mav.setViewName("/reports/optionList.jsp");
        mav.addObject("selectText", "Districts");
        return mav;
     }
    
    @RequestMapping(value = "/saveReportRequest.do", method = {RequestMethod.POST, RequestMethod.GET})
    public ModelAndView saveReportRequest(HttpSession session,
    		 @RequestParam(value = "startDate", required = true) Date startDate,
             @RequestParam(value = "endDate", required = true) Date endDate,
             @RequestParam(value = "entities", required = true) String entity3Ids,
             @RequestParam(value = "codeIds", required = true) String codeIds,
             @RequestParam(value = "reportId", required = true) String reportIds
            ) throws Exception {
       
    	User userDetails = (User) session.getAttribute("userDetails");
    	//we set up report request
    	reportRequest rr = new reportRequest();
    	rr.setStartDateTime(startDate);
    	rr.setEndDateTime(endDate);
    	rr.setProgramId(programId);
    	rr.setSystemUserId(userDetails.getId());
    	
    	Integer reportRequestId = reportmanager.saveReportRequest(rr);
    	
    	//we set up and insert entities
    	reportmanager.saveReportRequestEntities(entity3Ids, reportRequestId);
    	
    	//we set up and insert 
    	reportmanager.saveReportRequestContentCriteria(codeIds, reportRequestId);
    	
    	//run sp to update display table
    	reportmanager.updateReportDisplayTable(reportRequestId);
    	
        ModelAndView mav = new ModelAndView(new RedirectView("/reports/list"));
        return mav;
    }
    
    
}
