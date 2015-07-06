/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.rr.missouri.ui.importexport;

import com.registryKit.survey.surveyManager;
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
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import org.springframework.web.servlet.view.RedirectView;

/**
 *
 * @author chadmccue
 */
@Controller
@RequestMapping("/import-export")
public class importExportController {
    
    private static Integer moduleId = 4;
    
    @Autowired
    private userManager usermanager;
    
    @Autowired
    private surveyManager surveyManager;
    
    @Value("${programId}")
    private Integer programId;

    @Value("${topSecret}")
    private String topSecret;
    
    private static boolean allowImport = false;
    private static boolean allowExport = false;
    
    @RequestMapping(value = "", method = RequestMethod.GET)
    public ModelAndView importExport(HttpSession session, RedirectAttributes redirectAttr) throws Exception {

        /* Get a list of completed surveys the logged in user has access to */
        User userDetails = (User) session.getAttribute("userDetails");
        
        /* Get user permissions */
        userProgramModules modulePermissions = usermanager.getUserModulePermissions(programId, userDetails.getId(), moduleId);
        
        
        if(userDetails.getRoleId() == 2) {
            allowImport = false; //Import is not a feature for this registry
            allowExport = true;
        }
        else {
            allowImport = false; //Import is not a feature for this registry
            allowExport = modulePermissions.isAllowExport();
        }
        
        if(allowImport == true) {
            ModelAndView mav = new ModelAndView(new RedirectView("/import-export/import"));
            return mav;
        }
        else if(allowExport == true) {
           ModelAndView mav = new ModelAndView(new RedirectView("/import-export/export"));
           return mav;
        }
        else {
           ModelAndView mav = new ModelAndView(new RedirectView("/import-export/export"));
           return mav;
        }
         
    }
    
    /**
     * The '/export' GET request will display the export page. 
     * @param session
     * @return
     * @throws Exception 
     */
    @RequestMapping(value = "/export", method = RequestMethod.GET)
    public ModelAndView export(HttpSession session) throws Exception {

        ModelAndView mav = new ModelAndView();
        mav.setViewName("/export");
        mav.addObject("allowImport", allowImport);
        mav.addObject("allowExport", allowExport);
        
        /* Get a list of surveys  */
        List<surveys> surveyList = surveyManager.getProgramSurveys(programId);

        encryptObject encrypt = new encryptObject();
        Map<String, String> map;

        for (surveys survey : surveyList) {
            //Encrypt the use id to pass in the url
            map = new HashMap<String, String>();
            map.put("id", Integer.toString(survey.getId()));
            map.put("topSecret", topSecret);

            String[] encrypted = encrypt.encryptObject(map);

            survey.setEncryptedId(encrypted[0]);
            survey.setEncryptedSecret(encrypted[1]);

        }
        mav.addObject("surveys", surveyList);
        
        return mav;
         
    }
}
