/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.rr.missouri.ui.mci;

import com.registryKit.client.clientManager;
import com.registryKit.client.mciManager;
import com.registryKit.client.programClients;
import com.registryKit.client.storageClientAddressInfo;
import com.registryKit.client.storageClients;
import com.rr.missouri.ui.clients.client;
import com.rr.missouri.ui.security.decryptObject;
import com.rr.missouri.ui.security.encryptObject;
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
@RequestMapping("/MCI")
public class mciController {
    
    @Autowired
    private clientManager clientmanager;
    
    @Autowired
    private mciManager mcimanager;
    
    @Value("${programId}")
    private Integer programId;
    
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
    public ModelAndView listMCIPending(HttpServletRequest request, HttpServletResponse response, HttpSession session) throws Exception {
       
        ModelAndView mav = new ModelAndView();
        mav.setViewName("/pendingList");
        
        /* Get the client */
        List<Integer> clientIds = mcimanager.getPendingClients(programId);
        
        List<client> clients = new ArrayList<client>();
        
        /* Get the client details */
        if(!clientIds.isEmpty()) {
            for(Integer id : clientIds) {

                storageClients clientDetails = clientmanager.getClientDetails(id);
                storageClientAddressInfo addressInfo = clientmanager.getClientAddressInfo(id);
                
                client c = new client();
                c.setName(clientDetails.getFirstName()+" "+clientDetails.getLastName());
                c.setEmail(clientDetails.getEmail());
                c.setDateReferred(clientDetails.getDateCreated());
                c.setAddress(addressInfo.getAddress1());
                c.setAddress2(addressInfo.getAddress2());
                c.setCity(addressInfo.getCity());
                c.setState(addressInfo.getState());
                c.setZip(addressInfo.getZipCode());
                c.setPhoneNumber(addressInfo.getPhone1());
                
                Integer totalMatches = mcimanager.findSimilarMatchCount(programId, id);
                c.setSimilarMatches(totalMatches);
                
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
        mav.addObject("pending", clients);
        
        
        return mav;
    }
    
    /**
     * The '/review' GET request will display the selected client details page.
     * 
     * @param i The encrypted url value containing the selected user id
     * @param v The encrypted url value containing the secret decode key
     * @return
     * @throws Exception 
     */
    @RequestMapping(value = "/review", method = RequestMethod.GET)
    public ModelAndView getMCIReviewMatches(@RequestParam String i, @RequestParam String v) throws Exception {
        
        ModelAndView mav = new ModelAndView();
        mav.setViewName("/review");
        
        /* Decrypt the url */
        decryptObject decrypt = new decryptObject();
        
        Object obj = decrypt.decryptObject(i, v);
        
        String[] result = obj.toString().split((","));
        
        int clientId = Integer.parseInt(result[0].substring(4));
        
        storageClients clientDetails = clientmanager.getClientDetails(clientId);
        storageClientAddressInfo addressInfo = clientmanager.getClientAddressInfo(clientId);

        client c = new client();
        c.setName(clientDetails.getFirstName()+" "+clientDetails.getLastName());
        c.setEmail(clientDetails.getEmail());
        c.setDateReferred(clientDetails.getDateCreated());
        c.setDOB(clientDetails.getDob());
        c.setSourcePatientId(clientDetails.getSourcePatientId());
        c.setAddress(addressInfo.getAddress1());
        c.setAddress2(addressInfo.getAddress2());
        c.setCity(addressInfo.getCity());
        c.setState(addressInfo.getState());
        c.setZip(addressInfo.getZipCode());
        c.setPhoneNumber(addressInfo.getPhone1());
        mav.addObject("clientDetails", c);
        
        List<programClients> similarMatches = mcimanager.getSimilarClients(programId, clientId);
        List<client> similarClients = new ArrayList<client>();
        
        if(!similarMatches.isEmpty()) {
            
            for(programClients client : similarMatches) {
                
                storageClients similarclientDetails = clientmanager.getClientDetails(client.getId());
                storageClientAddressInfo similarclientaddressInfo = clientmanager.getClientAddressInfo(client.getId());

                client similarClient = new client();
                similarClient.setClientId(similarclientDetails.getId());
                similarClient.setName(similarclientDetails.getFirstName()+" "+similarclientDetails.getLastName());
                similarClient.setEmail(similarclientDetails.getEmail());
                similarClient.setDateReferred(similarclientDetails.getDateCreated());
                similarClient.setDOB(similarclientDetails.getDob());
                similarClient.setSourcePatientId(similarclientDetails.getSourcePatientId());
                similarClient.setAddress(similarclientaddressInfo.getAddress1());
                similarClient.setAddress2(similarclientaddressInfo.getAddress2());
                similarClient.setCity(similarclientaddressInfo.getCity());
                similarClient.setState(similarclientaddressInfo.getState());
                similarClient.setZip(similarclientaddressInfo.getZipCode());
                similarClient.setPhoneNumber(similarclientaddressInfo.getPhone1());
                
                similarClients.add(similarClient);
                
            }
        }
        mav.addObject("similarClients", similarClients);
        
        mav.addObject("clientId", clientId);
        mav.addObject("iparam", URLEncoder.encode(i,"UTF-8"));
        mav.addObject("vparam", URLEncoder.encode(v,"UTF-8"));
        
        return mav;
    }
    
    /**
     * The '/matchClient' POST request will handle updating the imported client based on the passed
     * in action.
  
     * @param chosenAction The action of what to do with the new imported client
     * @param newClientId The id of the new client
     * @param simClientId The id of the selected similar client
     * 
     * @return
     * @throws Exception 
     */
    @RequestMapping(value = "/matchClient", method = RequestMethod.POST)
    @ResponseBody public Integer matchClient(@RequestParam(value = "chosenAction", required = true) Integer chosenAction, @RequestParam(value = "newClientId", required = true) Integer newClientId, @RequestParam(value = "simClientId", required = true) Integer simClientId) throws Exception {
        
        
        /* Use Selected similar Clients data */
        if(chosenAction == 1) {
            
            /* Need to make the new client inactive */
            programClients newClientDetails = clientmanager.getProgramClient(newClientId);
            newClientDetails.setStatus(false);
            clientmanager.updateClient(newClientDetails);
            
            
            /* Create a new engagement for selected client */
            
            return 1;
        }
        
        /* Use New Clients data */
        else {
            
            /* Need to make the selected similar client inactive */
            programClients simClientDetails = clientmanager.getProgramClient(simClientId);
            simClientDetails.setStatus(false);
            clientmanager.updateClient(simClientDetails);
            
            /* Merge all surveys and engagements from similar client to new client */
            clientmanager.mergeClientData(newClientId, simClientId);
            
            programClients clientDetails = clientmanager.getProgramClient(newClientId);
            clientDetails.setMciReview(false);
            clientmanager.updateClient(clientDetails);
            
            /* Create a new engagement for selected client */
            
            
            return 2;
            
        }
        
        
        
    }
    
    
    /**
     * The '/enroll' POST request will handle enrolling the new client
     * 
     * @param newClientId The id of the new client
     * 
     * @return
     * @throws Exception 
     */
    @RequestMapping(value = "/enroll", method = RequestMethod.POST)
    @ResponseBody public Integer enrollMCIClient(@RequestParam(value = "newClientId", required = true) Integer newClientId) throws Exception {
        
        programClients clientDetails = clientmanager.getProgramClient(newClientId);
        clientDetails.setMciReview(false);
        clientmanager.updateClient(clientDetails);
        
        /* Create a new enrollment for selected client */
        
        return 1;
    }
    
}
