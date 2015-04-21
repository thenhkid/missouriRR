/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.rr.missouri.ui.clients;

import com.rr.missouri.ui.security.decryptObject;
import com.rr.missouri.ui.security.encryptObject;
import com.registryKit.user.User;
import com.registryKit.client.clientSearchFields;
import com.registryKit.client.modifiedFields;
import com.registryKit.program.programManager;
import com.registryKit.program.program;
import com.registryKit.client.programClientFields;
import com.registryKit.client.programClientSections;
import com.registryKit.client.programClients;
import com.registryKit.client.storageClientAddressInfo;
import com.registryKit.client.storageClients;
import com.registryKit.client.clientManager;
import com.registryKit.client.programPatientEntryMethods;
import java.net.URLEncoder;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
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
@RequestMapping("/clients")
public class clientController {
    
    @Autowired
    private programManager programmanager;
    
    @Autowired
    private clientManager clientmanager;
    
    @Value("${programId}")
    private Integer programId;
    
    private String searchParameters = "";
    
   @Value("${topSecret}")
   private String topSecret;
    
    /**
     * The '' request will display the list of client.
     *
     * @param request
     * @param response
     * @return	the administrator dashboard view
     * @throws Exception
     */
    @RequestMapping(value = "", method = RequestMethod.GET)
    public ModelAndView listClients(HttpServletRequest request, HttpServletResponse response, HttpSession session) throws Exception {
        
        program programDetails = programmanager.getProgramById(programId);

        ModelAndView mav = new ModelAndView();
        mav.setViewName("/clients");
        
        /* Get the client search fields */
        List<clientSearchFields> searchFields = clientmanager.getClientSearchFields(programId);
        
        String[] searchParams = searchParameters.split("^");

        for(clientSearchFields searchField : searchFields) {
           for(String param : searchParams) {
               if(param.split(":")[0].equals(searchField.getFieldId())) {
                   searchField.setFieldVal(param.split(":")[1]);
               }
           }
        }
        
        mav.addObject("searchFields", searchFields);
        
        /* Get the client entry methods */
        List<programPatientEntryMethods> entryMethods = clientmanager.getClientEntryMethods(programId);
        mav.addObject("entryMethods", entryMethods);
        
        return mav;
    }
    
    /**
     * The 'getClientList' GET request will return the view containing the table for the list of client based on the search parameters.
     * 
     * @param request
     * @param response
     * @param session
     * @param searchString  The string containing the list of search parameters.
     * @return
     * @throws Exception 
     */
    @RequestMapping(value = "getClientList", method = RequestMethod.GET)
    @ResponseBody public ModelAndView getClientList(HttpServletRequest request, HttpServletResponse response, HttpSession session, @RequestParam(value = "searchString", required = false) String searchString) throws Exception {
        
        ModelAndView mav = new ModelAndView();
        mav.setViewName("/clients/clientList");
        
        if(searchString != null) {
            searchParameters = searchString;
        } 
       
        /* Get the client */
        List<Integer> clientIds = clientmanager.getClients(programId, searchParameters);
        
        List<client> clients = new ArrayList<client>();
        
        /* Get the client details */
        if(!clientIds.isEmpty()) {
            for(Integer id : clientIds) {

                storageClients clientDetails = clientmanager.getClientDetails(id);
                storageClientAddressInfo addressInfo = clientmanager.getClientAddressInfo(id);
                
                client c = new client();
                if(clientDetails.getFirstName() != null && clientDetails.getLastName() != null) {
                    c.setName(clientDetails.getFirstName()+" "+clientDetails.getLastName());
                }
                c.setSourcePatientId(clientDetails.getSourcePatientId());
                c.setEmail(clientDetails.getEmail());
                c.setDateReferred(clientDetails.getDateCreated());
                c.setAddress(addressInfo.getAddress1());
                c.setAddress2(addressInfo.getAddress2());
                c.setCity(addressInfo.getCity());
                c.setState(addressInfo.getState());
                c.setZip(addressInfo.getZipCode());
                c.setPhoneNumber(addressInfo.getPhone1());
                
                encryptObject encrypt = new encryptObject();
                Map<String,String> map;
                
                //Encrypt the use id to pass in the url
                map = new HashMap<String,String>();
                map.put("id",Integer.toString(id));
                map.put("topSecret",topSecret);

                String[] encrypted = encrypt.encryptObject(map);

                c.setEncryptedId(encrypted[0]);
                c.setEncryptedSecret(encrypted[1]);
                
                clients.add(c);

            }
        }
        mav.addObject("clients", clients);
        
        return mav;
    }
    
    
    /**
     * The '/newClientNumberForm' request will display the form to enter a new client number.
     *
     *  @param session
     * @param redirectAttr
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/newClientNumberForm", method = RequestMethod.GET)
    public @ResponseBody ModelAndView newClientNumberForm(@RequestParam String msg) throws Exception {
        
        ModelAndView mav = new ModelAndView();
        mav.setViewName("/clients/newClientNumber");
        mav.addObject("msg", msg);
        
        return mav;
    }   
    
    /**
     * The '/checkForExistingClient' request will check to see if the entered client number already exists for the program
     *
     * @param clientNumber  The number entered for the new client
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/checkForExistingClient", method = RequestMethod.POST)
    public @ResponseBody Integer checkForExistingClient(@RequestParam Integer clientNumber) throws Exception {
        
        Integer foundClientId = clientmanager.findExistingClient(clientNumber, programId);
        
        if(foundClientId > 0) {
            return 1;
        }
        else {
            return 0;
        }
    }   
    
    /**
     * The '/createClientByEngagement' request will submit the new client number as a new client and return the 
     * encrypted id values.
     *
     * @param clientNumber  The number entered for the new client
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/createClientByEngagement", method = RequestMethod.POST)
    public @ResponseBody String createClientByEngagement(HttpSession session, @RequestParam Integer clientNumber) throws Exception {
        
        User userDetails = (User) session.getAttribute("userDetails");
        
        programClients newClient = new programClients();
        newClient.setProgramId(programId);
        newClient.setMciReview(false);
        newClient.setStatus(true);
        newClient.setSystemUserId(userDetails.getId());
        
        int clientId = clientmanager.saveNewClient(newClient);
        
        /* Create new storage_pateint entry */
        clientmanager.savePatientClientNumber(clientId, clientNumber);
        
        Map<String,String> map = new HashMap<String,String>();
        map.put("id",Integer.toString(clientId));
        map.put("topSecret",topSecret);
        
        encryptObject encrypt = new encryptObject();

        String[] encrypted = encrypt.encryptObject(map);
        
        String returnString = "i="+encrypted[0]+"&v="+encrypted[1];
        
        return returnString;
        
    }   
    
    
    /**
     * The '/details' GET request will display the selected client details page.
     * 
     * @param i The encrypted url value containing the selected user id
     * @param v The encrypted url value containing the secret decode key
     * @return
     * @throws Exception 
     */
    @RequestMapping(value = "/details", method = RequestMethod.GET)
    public ModelAndView getClientDetails(@RequestParam String i, @RequestParam String v) throws Exception {
        
        /* Decrypt the url */
        decryptObject decrypt = new decryptObject();
        
        Object obj = decrypt.decryptObject(i, v);
        
        String[] result = obj.toString().split((","));
        
        int clientId = Integer.parseInt(result[0].substring(4));
        
        List<programClientSections> sections = clientmanager.getSections(programId);
       
        /* Get the fields associated the section */
        List<programClientFields> fields = clientmanager.getClientFields(programId, clientId);
        
        programClients client = clientmanager.getProgramClient(clientId);
        client.setClientFields(fields);
        
        ModelAndView mav = new ModelAndView();
        mav.setViewName("/clientDetails");
        mav.addObject("sections", sections);
        mav.addObject("client", client);
        mav.addObject("iparam", URLEncoder.encode(i,"UTF-8"));
        mav.addObject("vparam", URLEncoder.encode(v,"UTF-8"));
        mav.addObject("clientId", clientId);
        
        return mav;
    }
    
    /**
     * The '/details' POST request will submit the client details form.
     * 
     * @param client    The object containing all the client detail form fields
     * @param i     The encrypted url value containing the selected user id
     * @param v     The encrypted url value containing the secret decode key
     * @return
     * @throws Exception 
     */
    @RequestMapping(value = "/details", method = RequestMethod.POST)
    public ModelAndView saveClientDetails(@ModelAttribute(value = "client") programClients client, HttpSession session, 
            RedirectAttributes redirectAttr, @RequestParam String action, @RequestParam String i, @RequestParam String v) throws Exception {
        
        /* Decrypt the url */
        decryptObject decrypt = new decryptObject();
        
        Object obj = decrypt.decryptObject(i, v);
        
        String[] result = obj.toString().split((","));
        
        int clientId = Integer.parseInt(result[0].substring(4));
        
        List<programClientFields> fields = client.getClientFields();
        

        if (null != fields && fields.size() > 0) {
           User userDetails = (User) session.getAttribute("userDetails");
           
           for (programClientFields formfield : fields) {
               clientmanager.updateClientFields(clientId, formfield.getSaveToTableName(), formfield.getSaveToTableCol(), formfield.getFieldValue(), formfield.getCurrFieldValue(), formfield.getFieldId(), formfield.getFieldType(), userDetails.getId());
            }
        }
            
        
        if (action.equals("save")) {
            redirectAttr.addFlashAttribute("savedStatus", "updated");
            ModelAndView mav = new ModelAndView(new RedirectView("/clients/details?i="+URLEncoder.encode(i,"UTF-8")+"&v="+URLEncoder.encode(v,"UTF-8")));
            return mav;
        } else {
            ModelAndView mav = new ModelAndView(new RedirectView("/clients?msg=updated"));
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
    @ResponseBody public ModelAndView getFieldModifications(HttpSession session, @RequestParam(value = "fieldId", required = true) Integer fieldId, @RequestParam(value = "clientId", required = true) Integer clientId) throws Exception {
        
        ModelAndView mav = new ModelAndView();
        mav.setViewName("/clients/modifiedList");
        
        /* Get the field modifications */
        List<modifiedFields> fieldModifications = clientmanager.getFieldModifications(programId, fieldId, clientId);
        mav.addObject("fieldModifications", fieldModifications);
        return mav;
        
        
    }
    
}
