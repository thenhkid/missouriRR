/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.rr.missouri.ui.reports;

import com.registryKit.hierarchy.hierarchyManager;
import com.registryKit.hierarchy.programHierarchyDetails;
import com.registryKit.hierarchy.programOrgHierarchy;
import com.registryKit.user.User;
import java.util.List;
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
    
   @Value("${programId}")
   private Integer programId;
   
   /**
     * The '' request will display a list of requested reports, if none are found, it will display new report form page
     *
     * @param request
     * @param response
     * @return	the administrator dashboard view
     * @throws Exception
     */
    @RequestMapping(value = "", method = RequestMethod.GET)
    public ModelAndView adHocReports(HttpSession session) throws Exception {
       
        ModelAndView mav = new ModelAndView();
        mav.setViewName("/request");
        
        User userDetails = (User) session.getAttribute("userDetails");
        
        List<programOrgHierarchy> orgHierarchyList = hierarchymanager.getProgramOrgHierarchy(programId);
        
        for(programOrgHierarchy hierarchy : orgHierarchyList) {
            if(hierarchy.getDspPos() == 1) {
                List<programHierarchyDetails> hierarchyItems = hierarchymanager.getProgramHierarchyItems(hierarchy.getId(), userDetails.getId());
                hierarchy.setProgramHierarchyDetails(hierarchyItems);
            }
        }
        
        mav.addObject("orgHierarchyList", orgHierarchyList);
        
        return mav;
    }
    
    
    @RequestMapping(value = "list", method = {RequestMethod.POST, RequestMethod.GET})
    public ModelAndView listReports(HttpSession session) throws Exception {
       
        ModelAndView mav = new ModelAndView();
        mav.setViewName("/list");
        return mav;
    }
    
    
    /**
     * The 'custom' request will display the list of custom generated reports.
     *
     * @param request
     * @param response
     * @return	the administrator dashboard view
     * @throws Exception
     */
    @RequestMapping(value = "/custom", method = RequestMethod.GET)
    public ModelAndView customReports(HttpSession session) throws Exception {
       
        ModelAndView mav = new ModelAndView();
        mav.setViewName("/custom");
        
        /* Get a list of custom reports */
        
        return mav;
    }
    
    
    /**
     * The 'customReport' request will display the selected custom Report
     *
     * @param request
     * @param response
     * @return	the administrator dashboard view
     * @throws Exception
     */
    @RequestMapping(value = "/customReport", method = RequestMethod.GET)
    public ModelAndView customReports(@RequestParam String r, HttpSession session) throws Exception {
       
        ModelAndView mav = new ModelAndView();
        mav.setViewName("/customReport");
        
        mav.addObject("reportName", r);
        
        return mav;
    }
    
}
