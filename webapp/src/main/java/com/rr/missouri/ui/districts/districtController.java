/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.rr.missouri.ui.districts;
 
import com.registryKit.hierarchy.hierarchyManager;
import com.registryKit.hierarchy.programHierarchyDetails;
import com.registryKit.hierarchy.programOrgHierarchy;
import com.registryKit.survey.surveyManager;
import com.registryKit.survey.surveys;
import com.registryKit.user.User;
import com.rr.missouri.ui.security.decryptObject;
import com.rr.missouri.ui.security.encryptObject;
import java.net.URLEncoder;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.ListIterator;
import java.util.Map;
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

/**
 *
 * @author chadmccue
 */
@Controller
@RequestMapping("/districts")
public class districtController {
    
    @Autowired
    private hierarchyManager hierarchymanager;
    
    @Autowired
    private surveyManager surveymanager;
    
    @Value("${programId}")
    private Integer programId;
    
    @Value("${topSecret}")
    private String topSecret;
    
    private String selCountyName;
    private Integer selCountyId = 0;
    private String selDistrictName;
    
    /**
     * The '' request will display the list of districts.
     *
     * @param request
     * @param response
     * @return	the administrator dashboard view
     * @throws Exception
     */
    @RequestMapping(value = "", method = RequestMethod.GET)
    public ModelAndView listDistricts(HttpSession session) throws Exception {
       
        ModelAndView mav = new ModelAndView();
        mav.setViewName("/districlist");
        
        User userDetails = (User) session.getAttribute("userDetails");
        
        programOrgHierarchy topLevel = hierarchymanager.getProgramOrgHierarchyBydspPos(1, programId);
        
        mav.addObject("topLevelName", topLevel.getName());
        
        /* Get a list of top level entities */
        List<programHierarchyDetails> entities = hierarchymanager.getProgramHierarchyItems(topLevel.getId(), userDetails.getId());
        
        mav.addObject("entities", entities);
        
        if(selCountyId == 0) {
            mav.addObject("selEntity", entities.get(0).getId());
        }
        else {
            mav.addObject("selEntity", selCountyId);
        }
        
        
        /* Get a list of districts for the first entity */
        mav.addObject("districts", "");
        
        return mav;
    }
    
    /**
     * The 'getDistrictList' GET request will return the list of districts based on the selected county.
     * 
     * @param request
     * @param response
     * @param session
     * @param searchString  The string containing the list of search parameters.
     * @return
     * @throws Exception 
     */
    @RequestMapping(value = "getDistrictList", method = RequestMethod.GET)
    @ResponseBody public ModelAndView getClientList(HttpServletRequest request, HttpServletResponse response, HttpSession session, @RequestParam(value = "countyId", required = false) Integer countyId) throws Exception {
        
        ModelAndView mav = new ModelAndView();
        mav.setViewName("/districts/districtList");
        
        User userDetails = (User) session.getAttribute("userDetails");
        
        List districts = hierarchymanager.getProgramOrgHierarchyItems(programId, 2, countyId, userDetails.getId());
        
        List<district> districtList = new ArrayList<district>();
        
        if(!districts.isEmpty() && districts.size() > 0) {
            
            for(ListIterator iter = districts.listIterator(); iter.hasNext(); ) {

                Object[] row = (Object[]) iter.next();
                
                district district = new district();
                district.setDistrictId(Integer.parseInt(row[0].toString()));
                district.setDistrictName(row[1].toString());
                district.setLastSurveyTaken("");
                district.setLastSurveyTakenOn(null);
                
                encryptObject encrypt = new encryptObject();
                Map<String,String> map;
                
                //Encrypt the use id to pass in the url
                map = new HashMap<String,String>();
                map.put("id",Integer.toString(Integer.parseInt(row[0].toString())));
                map.put("topSecret",topSecret);

                String[] encrypted = encrypt.encryptObject(map);

                district.setEncryptedId(encrypted[0]);
                district.setEncryptedSecret(encrypted[1]);
                
                districtList.add(district);
                
             }
        }
       
        mav.addObject("districts", districtList);
        
        /* Get the select county name */
        programHierarchyDetails countyDetails = hierarchymanager.getProgramHierarchyItemDetails(countyId);
        selCountyId = countyId;
        selCountyName = countyDetails.getName();
        
        return mav;
    }
    
    /**
     * The 'activityLog' GET request will populate the activity log page for the selected district.
     * 
     * @param i The encrypted id of the selected district
     * @param v
     * @param session
     * @return
     * @throws Exception 
     */
    @RequestMapping(value = "activityLog", method = RequestMethod.GET)
    public ModelAndView districtActivityLog(@RequestParam String i, @RequestParam String v, HttpSession session) throws Exception {
        
        ModelAndView mav = new ModelAndView();
        mav.setViewName("/activityLogs");
        
        mav.addObject("iparam", URLEncoder.encode(i,"UTF-8"));
        mav.addObject("vparam", URLEncoder.encode(v,"UTF-8"));
        
        /* Decrypt the url */
        decryptObject decrypt = new decryptObject();
        
        Object obj = decrypt.decryptObject(i, v);
        
        String[] result = obj.toString().split((","));
        
        int districtId = Integer.parseInt(result[0].substring(4));
        
        /* Get a list of surveys  */
        List<surveys> surveys = surveymanager.getProgramSurveys(programId);
        mav.addObject("surveys", surveys);
        
        mav.addObject("selSurvey", surveys.get(0).getId());
        mav.addObject("selCountyName", selCountyName);
        
        programHierarchyDetails districtDetails = hierarchymanager.getProgramHierarchyItemDetails(districtId);
        selDistrictName = districtDetails.getName();
        mav.addObject("selDistrictName", selDistrictName);
        
        return mav;
        
    }
    
    
    /**
     * The 'getDistrictActivityLog' GET request will return the list of activity logs based on the selected district/survey.
     * 
     * @param request
     * @param response
     * @param session
     * @param searchString  The string containing the list of search parameters.
     * @return
     * @throws Exception 
     */
    @RequestMapping(value = "getDistrictActivityLog", method = RequestMethod.GET)
    @ResponseBody public ModelAndView getDistrictActivityLog(HttpServletRequest request, HttpServletResponse response, HttpSession session, @RequestParam(value = "surveyId", required = false) Integer surveyId) throws Exception {
        
        ModelAndView mav = new ModelAndView();
        mav.setViewName("/districts/activityLogList");
        
        User userDetails = (User) session.getAttribute("userDetails");
        
        
       
        mav.addObject("activityLogs", "");
        
        return mav;
    }
    
}
