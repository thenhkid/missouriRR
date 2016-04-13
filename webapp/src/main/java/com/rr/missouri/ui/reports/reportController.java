/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.rr.missouri.ui.reports;

import com.registryKit.activityCode.activityCodeManager;
import com.registryKit.activityCode.activityCodes;
import com.registryKit.client.clientManager;
import com.registryKit.client.engagementManager;
import com.registryKit.hierarchy.hierarchyManager;
import com.registryKit.hierarchy.programHierarchyDetails;
import com.registryKit.hierarchy.programOrgHierarchy;
import com.registryKit.program.programManager;
import com.registryKit.report.reportChoices;
import com.registryKit.report.reportCriteriaField;
import com.registryKit.report.reportDetails;
import com.registryKit.report.reportManager;
import com.registryKit.report.reportRequest;
import com.registryKit.report.reportRequestDisplay;
import com.registryKit.report.reportType;
import com.registryKit.report.reportView;
import com.registryKit.user.User;
import com.registryKit.user.userManager;
import com.registryKit.user.userProgramModules;
import com.rr.missouri.ui.security.decryptObject;
import com.rr.missouri.ui.security.encryptObject;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.net.URLDecoder;
import java.text.SimpleDateFormat;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
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
@RequestMapping("/reports")
public class reportController {
    
   private static Integer moduleId = 3;
   
   @Autowired
   private hierarchyManager hierarchymanager;
   
   @Autowired
   private userManager usermanager;
   
   @Autowired
   private reportManager reportmanager;
   
   @Autowired
   private programManager programmanager;
   
   @Autowired
   private engagementManager engagementmanager;
   
   @Autowired
   private clientManager clientmanager;
   
   @Autowired
   private activityCodeManager activitycodemanager;
   
   private static boolean allowCreate = false;
   private static boolean allowEdit = false;
   private static boolean allowDelete = false;
   
    
   @Value("${programId}")
   private Integer programId;
   
   @Value("${topSecret}")
   private String topSecret;
   
    @RequestMapping(value={"", "/list"}, method = {RequestMethod.POST, RequestMethod.GET})
    public ModelAndView listReportsRequested(HttpSession session) throws Exception {
       
    	User userDetails = (User) session.getAttribute("userDetails");
    	
        ModelAndView mav = new ModelAndView();
        
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
        
        encryptObject encrypt = new encryptObject();
        Map<String, String> map;
        
        List <reportRequestDisplay> reportRequestList =  reportmanager.getReportRequestDisplays(programId, userDetails);
        for (reportRequestDisplay rrd : reportRequestList) {
        	rrd.setReportRequest(reportmanager.getReportRequestById(rrd.getReportRequestId()));
            //Encrypt the use id to pass in the url
            map = new HashMap<String, String>();
            map.put("id", Integer.toString(rrd.getReportRequestId()));
            map.put("topSecret", topSecret);

            String[] encrypted = encrypt.encryptObject(map);
            rrd.setEncryptedId(encrypted[0]);
            rrd.setEncryptedSecret(encrypted[1]);
        }
        
        
        mav.addObject("reportRequestList", reportRequestList);
        mav.setViewName("/list");
        return mav;
    }
   
    @RequestMapping(value = "/request", method = RequestMethod.GET)
    public ModelAndView reportRequestForm(HttpSession session) throws Exception {
       
        ModelAndView mav = new ModelAndView();
        mav.setViewName("/request");
        
        User userDetails = (User) session.getAttribute("userDetails");
        List <Integer> reportLevels = Arrays.asList(1,2,3);
        boolean adminUser = false;
        if (userDetails.getRoleId() == 3) {
            userProgramModules modulePermissions = usermanager.getUserModulePermissions(programId, userDetails.getId(), moduleId);
            reportLevels = reportmanager.getReportLevels(modulePermissions); 
        }
        else {
            adminUser = true;
        }
        
        //this returns the report type list for this program
        List<reportType> reportTypeList = reportmanager.getReportTypes(programId, false,  reportLevels);
        mav.addObject("reportTypes", reportTypeList);
        
        //these are the surveys, but should be populated with /availableReports.do
        List<reportDetails> reportList = reportmanager.getReportsForType(programId, false, reportTypeList.get(0).getId(), reportLevels);
        mav.addObject("reportList", reportList);
        reportType rt = reportmanager.getReportTypeById(reportTypeList.get(0).getId());
        mav.addObject("reportType", rt);
        
        List<programOrgHierarchy> orgHierarchyList = hierarchymanager.getProgramOrgHierarchy(programId);
        
        //entity 1 items
        for(programOrgHierarchy hierarchy : orgHierarchyList) {
            if (userDetails.getRoleId() != 3) {
            		List<programHierarchyDetails> hierarchyItems = hierarchymanager.getProgramHierarchyItemsForStatus(hierarchy.getId(), 0, true);
                    hierarchy.setProgramHierarchyDetails(hierarchyItems);	
                } else {
            		List<programHierarchyDetails> hierarchyItems = hierarchymanager.getProgramHierarchyItemsForStatus(hierarchy.getId(), userDetails.getId(), true);
                    hierarchy.setProgramHierarchyDetails(hierarchyItems);
                }
        }
        
        mav.addObject("entity1List", orgHierarchyList.get(0).getProgramHierarchyDetails());
        mav.addObject("entity2List", orgHierarchyList.get(1).getProgramHierarchyDetails());
        mav.addObject("entity3List", orgHierarchyList.get(2).getProgramHierarchyDetails());
        if( orgHierarchyList.get(0).getProgramHierarchyDetails().size() == 1) {
        	mav.addObject("entityList", orgHierarchyList.get(1).getProgramHierarchyDetails());
            mav.addObject("tier", 2);
        }
        //codeId list depends on selection criteria
        mav.addObject("orgHierarchyList", orgHierarchyList);
        mav.addObject("entity1ListSize", orgHierarchyList.get(0).getProgramHierarchyDetails().size());
        List<activityCodes> codeList = new ArrayList<activityCodes>();
        		//activitycodemanager.getActivityCodesByProgram(programId);
        mav.addObject("codeList", codeList);
        
        return mav;
    }

    
    //this returns available reports for selected type
    @RequestMapping(value = "/availableReports.do", method = RequestMethod.POST)
    public @ResponseBody
    ModelAndView getReportList(HttpSession session,
            @RequestParam(value = "reportTypeId", required = false) Integer reportTypeId,
            @RequestParam(value = "entity1ListSize", required = false) Integer entity1ListSize 
    )
            throws Exception {
    	
    	User userDetails = (User) session.getAttribute("userDetails");
    	userProgramModules modulePermissions = usermanager.getUserModulePermissions(programId, userDetails.getId(), moduleId);
    	List <Integer> reportLevels = Arrays.asList(1,2,3);
    	if (userDetails.getRoleId() != 1 && userDetails.getRoleId() != 2 && userDetails.getRoleId() != 4) {
    		reportLevels = reportmanager.getReportLevels(modulePermissions);  
    	}
        
    	List <reportDetails> availableReports = reportmanager.getReportsForType(programId, false, reportTypeId, reportLevels);
    	reportType rt = reportmanager.getReportTypeById(reportTypeId);
    	List<programOrgHierarchy> orgHierarchyList = hierarchymanager.getProgramOrgHierarchy(programId);
    	
    	ModelAndView mav = new ModelAndView();
        mav.setViewName("/reports/reportDiv");
        mav.addObject("orgHierarchyList", orgHierarchyList);
        mav.addObject("reportList", availableReports);
        mav.addObject("entity1ListSize", entity1ListSize);
        mav.addObject("reportType", rt);
        
        
        return mav;
     }
    
    
    //this returns entities 2 & 3
    @RequestMapping(value = "/returnEntityList.do", method = RequestMethod.POST)
    public @ResponseBody
    ModelAndView getEntities (HttpSession session, HttpServletRequest request,
            @RequestParam(value = "entityIds", required = false)List <Integer> entityIds,
            @RequestParam(value = "tier", required = true) Integer tier,
            @RequestParam(value = "reportIds", required = false) List <Integer> reportIds
    )
            throws Exception {
    	
    	ModelAndView mav = new ModelAndView();
    	
    	User userDetails = (User) session.getAttribute("userDetails");
        
        List<programOrgHierarchy> orgHierarchyList = hierarchymanager.getProgramOrgHierarchy(programId);
        List<programHierarchyDetails> hierarchyItems = null;
        //look up all the entity2Ids for entity1Ids for user who has permission
    	if (userDetails.getRoleId() != 3) { 
    		hierarchyItems = hierarchymanager.getProgramHierarchyItemsByAssocList(orgHierarchyList.get(tier).getId(), entityIds, 0);
        } else {
    		hierarchyItems = hierarchymanager.getProgramHierarchyItemsByAssocList(orgHierarchyList.get(tier).getId(), entityIds, userDetails.getId());
        }
    	
    	Integer newTier = 2;
    	String repView = "/reports/entity2Div";
    	if (tier == 2) {
    		newTier = 3;
    		repView = "/reports/entity3Div";
    		if(reportIds.get(0) == 36) {
            	reportCriteriaField rcf = reportmanager.getreportCriteriaFieldByOrder(programId, reportIds.get(0), 1);
            	mav.addObject("reportCriteriaField", rcf);
            }
    	}
    	
    	
        mav.setViewName(repView);
        
    	//we will modify here if there are report logic

    	mav.addObject("orgHierarchyList", orgHierarchyList);
        mav.addObject("entityList", hierarchyItems);
        mav.addObject("tier", newTier);
        
        
        
        return mav;
     }
    
    
  //narrows down code list by report
    @RequestMapping(value = "/getCodeList.do", method = RequestMethod.POST)
    public @ResponseBody
    ModelAndView getCodeList(HttpSession session,
            @RequestParam(value = "startDate", required = true) String startDate,
            @RequestParam(value = "endDate", required = true) String endDate,
            @RequestParam(value = "entity3Ids", required = true) List <Integer> entity3Ids,
            @RequestParam(value = "reportIds", required = true) List <Integer> reportIds
    )
            throws Exception {
    	User userDetails = (User) session.getAttribute("userDetails");
    	
    	List<programOrgHierarchy> orgHierarchyList = hierarchymanager.getProgramOrgHierarchy(programId);
    	
    	//need to rearrange date 
    	
    	SimpleDateFormat dateformat = new SimpleDateFormat("MM/dd/yyyy");
    	Date sd = dateformat.parse(startDate);
 	    Date ed = dateformat.parse(endDate);
        
    	//set up report request
    	reportRequest rr = new reportRequest();
    	rr.setProgramId(programId);
    	rr.setProgramHeirarchyId(orgHierarchyList.get(orgHierarchyList.size()-1).getId());
    	rr.setStartDateTime(sd);
	    rr.setEndDateTime(ed);
	    rr.setEntity3Ids(entity3Ids);
	    rr.setReportIds(reportIds);
    	    	
    	List<activityCodes> codeList = reportmanager.getAvailableReportRequestCodeList(rr, userDetails);
        
    	 ModelAndView mav = new ModelAndView();
         mav.setViewName("/reports/criteriaDiv");
         mav.addObject("codeList", codeList);
         
        return mav;
     }
    
    
    //narrows down criteria list by report
    @RequestMapping(value = "/getCriteriaList.do", method = RequestMethod.POST)
    public @ResponseBody
    ModelAndView getCriteriaList(HttpSession session,
            @RequestParam(value = "startDate", required = true) String startDate,
            @RequestParam(value = "endDate", required = true) String endDate,
            @RequestParam(value = "entity3Ids", required = true) List <Integer> entity3Ids,
            @RequestParam(value = "reportIds", required = true) List <Integer> reportIds    
    )
            throws Exception {
    	List<programOrgHierarchy> orgHierarchyList = hierarchymanager.getProgramOrgHierarchy(programId);
    	
    	//need to rearrange date 
    	
    	SimpleDateFormat dateformat = new SimpleDateFormat("MM/dd/yyyy");
    	Date sd = dateformat.parse(startDate);
 	    Date ed = dateformat.parse(endDate);
        
        //set up report request
    	reportRequest rr = new reportRequest();
    	rr.setProgramId(programId);
    	rr.setProgramHeirarchyId(orgHierarchyList.get(orgHierarchyList.size()-1).getId());
    	rr.setStartDateTime(sd);
	    rr.setEndDateTime(ed);
	    rr.setEntity3Ids(entity3Ids);
	    rr.setReportIds(reportIds);
    	
    	reportCriteriaField rcf = reportmanager.getreportCriteriaFieldByOrder(programId, reportIds.get(0), 1);
    	
    	//if it contains null, we switch out to not provided
    	List <reportChoices> criteriaList = reportmanager.getCriteriaListWithCW(rcf, rr);
    	if (criteriaList.size() > 0) {
    		//we check for null and replace
    		if (criteriaList.get(0).getDisplayVal() == null) {
    			reportChoices rc = new reportChoices();
    			rc.setDisplayVal("Not Provided");
    			rc.setInsertVal("^^^^^");
    			criteriaList.set( 0, rc);
    		}
    	}
	    
        ModelAndView mav = new ModelAndView();
        mav.setViewName("/reports/criteriaDiv");
        mav.addObject("criteriaList", criteriaList);
        mav.addObject("reportCriteriaField", rcf);
        
        return mav;
     }
    
    @RequestMapping(value = "/saveReportRequest.do", method = {RequestMethod.POST, RequestMethod.GET})
    public ModelAndView saveReportRequest(HttpSession session,
    		 @RequestParam(value = "startDate", required = true) String startDate,
             @RequestParam(value = "endDate", required = true) String endDate,
             @RequestParam(value = "reportTypeId", required = true) Integer reportTypeId,
             @RequestParam(value = "entity3Ids", required = true) String entity3Ids,
             @RequestParam(value = "codeIds", required = false) String codeIds,
             @RequestParam(value = "criteriaValues", required = false) String criteriaValues,            
             @RequestParam(value = "reportIds", required = true) String reportIds,
             @RequestParam(value = "reportCriteriaId", required = false) Integer reportCriteriaId
            ) throws Exception {
       
    	User userDetails = (User) session.getAttribute("userDetails");
    	
    	reportRequest rr = new reportRequest();
    	
    	SimpleDateFormat dateformat = new SimpleDateFormat("MM/dd/yyyy");
    	Date sd = dateformat.parse(startDate);
 	    Date ed = dateformat.parse(endDate);
        
    	rr.setStartDateTime(sd);
    	rr.setEndDateTime(ed);
    	rr.setReportTypeId(reportTypeId);
    	rr.setProgramId(programId);
    	rr.setSystemUserId(userDetails.getId());
    	
    	Integer reportRequestId = reportmanager.saveReportRequest(rr);
    	
    	//we set up and insert entities
    	if(!reportIds.equalsIgnoreCase("15")) {
    		reportmanager.saveReportRequestEntities(entity3Ids, reportRequestId);
    	}
    	//we set up and insert reportId
    	reportmanager.saveReportRequestReportIds(reportIds, reportRequestId);
    	
    	if (codeIds.length() > 0) {
    		reportmanager.saveReportRequestContentCriteria(codeIds, reportRequestId);
    	}
    	
    	if (criteriaValues.length() > 0) {
    		reportmanager.saveReportRequestCriteria(criteriaValues, reportRequestId, reportCriteriaId);
    	}
    	
    	//run sp to update display table
    	reportmanager.updateReportDisplayTable(reportRequestId);
    	
        ModelAndView mav = new ModelAndView(new RedirectView("/reports/list"));
        return mav;
    }
    
    
    @RequestMapping(value = "/DLReport", method = {RequestMethod.GET})
    public void DLReport(@RequestParam String i, @RequestParam String v, 
    		HttpSession session, HttpServletResponse response) throws Exception {
    	
    	Integer reportRequestId = 0;
    	reportView rv = new reportView();
    	boolean canViewReport = false;
    	
    	if (session.getAttribute("userDetails") != null) {
    		User userDetails = (User) session.getAttribute("userDetails");
    		//1 decrpt and get the reportId
            decryptObject decrypt = new decryptObject();
            Object obj = decrypt.decryptObject(i, v);
            String[] result = obj.toString().split((","));
            reportRequestId = Integer.parseInt(result[0].substring(4));
            rv.setReportRequestId(reportRequestId);
            rv.setReportAction("Accessed report link");
            rv.setSystemUserId(userDetails.getId());
  	        reportmanager.saveReportView(rv);
            //now we get the report details
            reportRequest rr = reportmanager.getReportRequestById(reportRequestId);
            
            if (rr != null) {
            	//we check permission and program
            	if (userDetails.getRoleId() ==3 && rr.getSystemUserId() == userDetails.getId() && rr.getProgramId() == programId)  {
            		canViewReport = true;
            	} else if (userDetails.getRoleId() != 3 && rr.getProgramId() == programId) {
            		canViewReport = true;
            	}
            } 
            //we log them, grab report for them to download
            //if report doesn't exist we send them back to list with a message
            if (!canViewReport) {
	       		 rv = new reportView();
	       		 rv.setReportRequestId(reportRequestId);
	       		 rv.setSystemUserId(userDetails.getId());
	       		 rv.setReportAction("User does not have permission to view report");
	       		 reportmanager.saveReportView(rv);
	       		 throw new Exception("user does not have permission - " + reportRequestId);
            	}   else {
            	//generate the report for user to download
            	//need to get report path
            	String filePath= reportmanager.getReportPath(programId);
            	String fileName = rr.getReportFileName();
            	try {
            	File f = new File(filePath+fileName);
	            	 if(!f.exists()){
	            		 throw new Exception("Error with File " +filePath + fileName);
	            	 }
            	 } catch (Exception e) {
            		 try {
           	    	  //update file to error
           	    	  rr.setStatusId(5);
           	    	  reportmanager.updateReportRequest(rr);
           	    	  throw new Exception("File does not exists " +filePath + fileName);
           	      } catch (Exception ex1) {
           	    	  throw new Exception("File does not exists " +filePath + fileName + ex1);
           	      }
       	    	  
       	      	}

          	  
            	try {
            		  // get your file as InputStream
            		  InputStream is = new FileInputStream(filePath+fileName);
            	      // copy it to response's OutputStream
            	      
            	      String mimeType = "application/octet-stream";
            		  response.setContentType(mimeType);
            		  response.setHeader("Content-Transfer-Encoding", "binary");
                      response.setHeader("Content-Disposition", "attachment;filename=\"" + fileName + "\"");
                      org.apache.commons.io.IOUtils.copy(is, response.getOutputStream());
                      response.flushBuffer();
            	      is.close();
            	      rv = new reportView();
            	      rv.setSystemUserId(userDetails.getId());
            	      rv.setReportRequestId(reportRequestId);
                      rv.setReportAction("Viewed Report");
                      reportmanager.saveReportView(rv);
                      //update status
                      if (rr.getStatusId() == 3) {
                    	  rr.setStatusId(4);
                    	  reportmanager.updateReportRequest(rr);
                      }
            	    } catch (IOException ex) {
            	    	ex.printStackTrace();
            	    	System.out.println("Error writing file to output stream. Filename was '{}'"+ fileName + ex);
            	      try {
            	    	  //update file to error
            	    	  rr.setStatusId(5);
            	    	  reportmanager.updateReportRequest(rr);
            	    	  throw new Exception("Error with File " +filePath + fileName + ex);
            	      } catch (Exception e) {
            	    	  throw new Exception("Error with File " +filePath + fileName + ex);
            	      }
            	    }
            	}
            
        } else {
    		//someone somehow got to this link, we just log
    		//we log who is accessing 
            //now we have report id, we check to see which program it belongs to and if the user has permission
            rv.setReportRequestId(reportRequestId);
            rv.setReportAction("Accessed report link - no user session found");
            reportmanager.saveReportView(rv);
            throw new Exception("invalid report download - " + reportRequestId);
    		
    	}
    	
    }  
    
  //this returns available reports for selected type
    @RequestMapping(value = "/deleteReportRequest.do", method = RequestMethod.POST)
    public @ResponseBody
    Integer deleteReport(HttpSession session, RedirectAttributes redirectAttr,
    		@RequestParam String reli, @RequestParam String relv                
    )
            throws Exception {
    	
    	String i = URLDecoder.decode(reli, "UTF-8");
    	String v = URLDecoder.decode(relv, "UTF-8");
    	
    	decryptObject decrypt = new decryptObject();
        Object obj = decrypt.decryptObject(i, v);
        String[] result = obj.toString().split((","));
        Integer reportRequestId = Integer.parseInt(result[0].substring(4));
    	
    	User userDetails = (User) session.getAttribute("userDetails");
    	reportView rv = new reportView();
	    rv.setSystemUserId(userDetails.getId());
	    rv.setReportRequestId(reportRequestId);
        rv.setReportAction("Deleted Report");
        reportmanager.saveReportView(rv);
    	
    	reportRequest rr = reportmanager.getReportRequestById(reportRequestId);
    	if (rr.getStatusId() == 3 || rr.getStatusId() == 4) {
    		//we rename file
        	reportmanager.deleteReportFile(rr);
    	}
    	redirectAttr.addFlashAttribute("msg", "Deleted");
    	rr.setStatusId(6);
    	reportmanager.updateReportRequest(rr);
    	
    	return 1;
     }

}

