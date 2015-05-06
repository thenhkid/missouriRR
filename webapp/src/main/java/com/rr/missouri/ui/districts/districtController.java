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
    
    @Value("${programId}")
    private Integer programId;
    
    @Value("${topSecret}")
   private String topSecret;
    
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
        mav.addObject("selEntity", entities.get(0).getId());
        
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
        
        return mav;
    }
    
}
