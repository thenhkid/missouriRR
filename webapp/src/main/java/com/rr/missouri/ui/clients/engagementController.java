/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.rr.missouri.ui.clients;

import com.registryKit.client.clientManager;
import com.registryKit.client.engagementManager;
import com.registryKit.client.engagements;
import com.registryKit.client.modifiedEngagementFields;
import com.registryKit.client.programEngagementFields;
import com.registryKit.client.programEngagementSections;
import com.registryKit.client.storageClientAddressInfo;
import com.registryKit.client.storageClients;
import com.registryKit.user.User;
import com.rr.missouri.ui.security.decryptObject;
import java.net.URLEncoder;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import java.util.Locale;
import javax.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
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
@RequestMapping("/clients/engagements")
public class engagementController {
    
    @Autowired
    private clientManager clientmanager;
    
    @Autowired
    private engagementManager engagementmanager;
    
    @Value("${programId}")
    private Integer programId;
    
    /**
     * The '' request will display the list of client engagements.
     *
     * @param request
     * @param response
     * @return	the client engagement list view
     * @throws Exception
     */
    @RequestMapping(value = "", method = RequestMethod.GET)
    public ModelAndView listEngagements(@RequestParam String i, @RequestParam String v) throws Exception {
        
        ModelAndView mav = new ModelAndView();
        mav.setViewName("/engagements");
        mav.addObject("iparam", URLEncoder.encode(i,"UTF-8"));
        mav.addObject("vparam", URLEncoder.encode(v,"UTF-8"));
        
        /* Decrypt the url */
        decryptObject decrypt = new decryptObject();
        
        Object obj = decrypt.decryptObject(i, v);
        
        String[] result = obj.toString().split((","));
        
        int clientId = Integer.parseInt(result[0].substring(4));
        
        clientSummary summary = new clientSummary();
        
        storageClients clientDetails = clientmanager.getClientDetails(clientId);
        storageClientAddressInfo addressInfo = clientmanager.getClientAddressInfo(clientId);
        
        summary.setName(clientDetails.getFirstName()+" "+clientDetails.getLastName());
        summary.setSourcePatientId(clientDetails.getSourcePatientId());
        summary.setDateReferred(clientDetails.getDateCreated());
        summary.setAddress(addressInfo.getAddress1());
        summary.setAddress2(addressInfo.getAddress2());
        summary.setCity(addressInfo.getCity());
        summary.setState(addressInfo.getState());
        summary.setZip(addressInfo.getZipCode());
        summary.setPhoneNumber(addressInfo.getPhone1());
        summary.setDob(clientDetails.getDob());
        
        mav.addObject("summary", summary);
        
        /* Get the client engagements */
        List<engagements> engagements = engagementmanager.getEngagements(clientId, programId);
        
        mav.addObject("engagements", engagements);
        
        return mav;
    }
    
    
    /**
     * The '/details' request will display the details for the selected engagement.
     *
     * @param request
     * @param response
     * @return	the client engagement list view
     * @throws Exception
     */
    @RequestMapping(value = "/details", method = RequestMethod.GET)
    public ModelAndView engagementDetails(@RequestParam String i, @RequestParam String v, @RequestParam(value = "e", required = false) String e, HttpSession session) throws Exception {
        
        if(e == null) {
            e = "0";
        }
        
        ModelAndView mav = new ModelAndView();
        mav.setViewName("/engagementDetails");
        
        /* Decrypt the url */
        decryptObject decrypt = new decryptObject();
        
        Object obj = decrypt.decryptObject(i, v);
        
        String[] result = obj.toString().split((","));
        
        int clientId = Integer.parseInt(result[0].substring(4));
        
        clientSummary summary = new clientSummary();
        
        storageClients clientDetails = clientmanager.getClientDetails(clientId);
        storageClientAddressInfo addressInfo = clientmanager.getClientAddressInfo(clientId);
        
        summary.setName(clientDetails.getFirstName()+" "+clientDetails.getLastName());
        summary.setSourcePatientId(clientDetails.getSourcePatientId());
        summary.setDateReferred(clientDetails.getDateCreated());
        summary.setAddress(addressInfo.getAddress1());
        summary.setAddress2(addressInfo.getAddress2());
        summary.setCity(addressInfo.getCity());
        summary.setState(addressInfo.getState());
        summary.setZip(addressInfo.getZipCode());
        summary.setPhoneNumber(addressInfo.getPhone1());
        summary.setDob(clientDetails.getDob());
        
        mav.addObject("summary", summary);
        
        List<programEngagementSections> sections = engagementmanager.getSections(programId);
       
        /* Get the fields associated the section */
        List<programEngagementFields> fields = engagementmanager.getEngagementFields(programId, Integer.parseInt(e), clientId);
        
        engagements engagement;
        if(Integer.parseInt(e) == 0) {
             User userDetails = (User) session.getAttribute("userDetails");
            
            engagement = new engagements();
            engagement.setProgramId(programId);
            engagement.setProgramPatientId(clientId);
            engagement.setEngagementFields(fields);
            engagement.setSystemUserId((Integer) userDetails.getId());
            engagement.setEnteredBy(userDetails.getFirstName()+" "+userDetails.getLastName());
        }
        else {
            engagement = engagementmanager.getEngagementDetails(Integer.parseInt(e));
            engagement.setEngagementFields(fields);
        }
        
        mav.addObject("sections", sections);
        mav.addObject("engagement", engagement);
        mav.addObject("iparam", URLEncoder.encode(i,"UTF-8"));
        mav.addObject("vparam", URLEncoder.encode(v,"UTF-8"));
        mav.addObject("engagementId", e);
        
        return mav;
    }
    
    /**
     * The '/details' GET request will display the selected client details page.
     * 
     * @param i The encrypted url value containing the selected user id
     * @param v The encrypted url value containing the secret decode key
     * @return
     * @throws Exception 
     */
    @RequestMapping(value = "/details", method = RequestMethod.POST)
    public ModelAndView saveClientDetails(@ModelAttribute(value = "engagement") engagements engagement, HttpSession session, 
            RedirectAttributes redirectAttr, @RequestParam String action, @RequestParam String i, @RequestParam String v) throws Exception {
        
        /* Decrypt the url */
        decryptObject decrypt = new decryptObject();
        
        Object obj = decrypt.decryptObject(i, v);
        
        String[] result = obj.toString().split((","));
        
        int clientId = Integer.parseInt(result[0].substring(4));
        
        List<programEngagementFields> fields = engagement.getEngagementFields();
        
        int selEngagementId = 0;
        String msg;
        boolean newEngagement = false;
        if(engagement.getId() == 0) {
            selEngagementId = engagementmanager.saveEngagement(engagement);
            msg = "created";
            newEngagement = true;
        }
        else {
            selEngagementId = engagement.getId();
            msg = "updated";
        }

        if (null != fields && fields.size() > 0) {
           User userDetails = (User) session.getAttribute("userDetails");
           
           for (programEngagementFields formfield : fields) {
               engagementmanager.updateEngagementFields(newEngagement, selEngagementId, clientId, formfield.getSaveToTableName(), formfield.getSaveToTableCol(), formfield.getFieldValue(), formfield.getCurrFieldValue(), formfield.getFieldId(), formfield.getFieldType(), userDetails.getId());
            }
        }
            
        if (action.equals("save")) {
            redirectAttr.addFlashAttribute("savedStatus", "updated");
            ModelAndView mav = new ModelAndView(new RedirectView("/clients/engagements/details?i="+URLEncoder.encode(i,"UTF-8")+"&e="+selEngagementId+"&v="+URLEncoder.encode(v,"UTF-8")+"&msg="+msg));
            return mav;
        } else {
            ModelAndView mav = new ModelAndView(new RedirectView("/clients/engagements?i="+URLEncoder.encode(i,"UTF-8")+"&v="+URLEncoder.encode(v,"UTF-8")+"&msg="+msg));
                    
            return mav;
        }
        
    }
    
    /**
     * The 'getFieldModifications' GET request will return the list of field modifications.
     * 
     * @param session
     * @param fieldId The field to retrieve modifications for
     * @param clientId  The client to get the modifications for
     * @return  The request will return the modifiedList view
     * @throws Exception 
     */
    @RequestMapping(value = "/getFieldModifications", method = RequestMethod.GET)
    @ResponseBody public ModelAndView getFieldModifications(HttpSession session, @RequestParam(value = "fieldId", required = true) Integer fieldId, @RequestParam(value = "engagementId", required = true) Integer engagementId) throws Exception {
        
        ModelAndView mav = new ModelAndView();
        mav.setViewName("/clients/modifiedList");
        
        /* Get the field modifications */
        List<modifiedEngagementFields> fieldModifications = engagementmanager.getFieldModifications(programId, fieldId, engagementId);
        mav.addObject("fieldModifications", fieldModifications);
        return mav;
        
        
    }
    
}
