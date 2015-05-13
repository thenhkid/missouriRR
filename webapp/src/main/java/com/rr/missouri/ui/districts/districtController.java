/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.rr.missouri.ui.districts;
 
import com.registryKit.hierarchy.hierarchyManager;
import com.registryKit.hierarchy.programHierarchyDetails;
import com.registryKit.hierarchy.programOrgHierarchy;
import com.registryKit.user.User;
import com.rr.missouri.ui.security.encryptObject;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.ListIterator;
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

/**
 *
 * @author chadmccue
 */
@Controller
@RequestMapping("/districts")
public class districtController {
    
    @Autowired
    private hierarchyManager hierarchymanager;
    
    @Value("${programId}")
    private Integer programId;
    
    @Value("${topSecret}")
    private String topSecret;
    
    /**
     * The 'getDistrictList.do' GET request will return the list of counties and districts available to the user.
     * @param session
     * @param surveyId
     * @return
     * @throws Exception 
     */
    @RequestMapping(value = "getDistrictList.do", method = RequestMethod.GET) 
    @ResponseBody public ModelAndView getDistrictList(HttpSession session, @RequestParam(value = "surveyId", required = false) Integer surveyId) throws Exception {
        
        ModelAndView mav = new ModelAndView();
        mav.setViewName("/districts/districtSelect");
        
        User userDetails = (User) session.getAttribute("userDetails");
        
        programOrgHierarchy topLevel = hierarchymanager.getProgramOrgHierarchyBydspPos(1, programId);
        
        /* Get a list of top level entities */
        List<programHierarchyDetails> counties = hierarchymanager.getProgramHierarchyItems(topLevel.getId(), userDetails.getId());
        
        List<county> countyList = new ArrayList<county>();
        
        encryptObject encrypt = new encryptObject();
        Map<String,String> map;
        
        for(programHierarchyDetails county : counties) {
            
            county newCounty = new county();
            newCounty.setCountyId(county.getId());
            newCounty.setCountyName(county.getName());
            
            List districts = hierarchymanager.getProgramOrgHierarchyItems(programId, 2, county.getId(), userDetails.getId());
        
            List<district> districtList = new ArrayList<district>();

            if(!districts.isEmpty() && districts.size() > 0) {

                for(ListIterator iter = districts.listIterator(); iter.hasNext(); ) {

                    Object[] row = (Object[]) iter.next();

                    district district = new district();
                    district.setDistrictId(Integer.parseInt(row[0].toString()));
                    district.setDistrictName(row[1].toString());
                    district.setLastSurveyTaken("");
                    district.setLastSurveyTakenOn(null);

                    //Encrypt the use id to pass in the url
                    map = new HashMap<String,String>();
                    map.put("id",Integer.toString(Integer.parseInt(row[0].toString())));
                    map.put("topSecret",topSecret);

                    String[] encrypted = encrypt.encryptObject(map);

                    district.setEncryptedId(encrypted[0]);
                    district.setEncryptedSecret(encrypted[1]);

                    districtList.add(district);

                 }
                
                newCounty.setDistrictList(districtList);
            }
            
            countyList.add(newCounty);
        }
        
        mav.addObject("countyList", countyList);
        
        //Encrypt the use id to pass in the url
        mav.addObject("surveyId", surveyId);
        
        return mav;
        
    }
    
}
