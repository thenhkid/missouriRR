/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.rr.missouri.ui.hierarchy;


import com.registryKit.hierarchy.hierarchyManager;
import com.registryKit.hierarchy.programOrgHierarchy;
import com.registryKit.hierarchy.programHierarchyDetails;
import com.registryKit.hierarchy.programServices;
import com.registryKit.hierarchy.provider;
import com.registryKit.hierarchy.providerHierarchyAssoc;
import com.registryKit.hierarchy.providerServices;
import com.registryKit.hierarchy.serviceManager;
import com.registryKit.user.User;
import com.rr.missouri.ui.reference.USStateList;
import com.rr.missouri.ui.security.decryptObject;
import com.rr.missouri.ui.security.encryptObject;
import java.net.URLEncoder;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import javax.servlet.http.HttpSession;
import javax.validation.Valid;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.validation.BindingResult;
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
@RequestMapping("/hierarchy")
public class hierarchyController {
    
    @Autowired
    private hierarchyManager hierarchymanager;
    
    @Autowired
    private serviceManager servicemanager;
    
    @Value("${programId}")
    private Integer programId;
    
     List<programOrgHierarchy> orgHierarchyList = null;
     
     private String topSecret = "What goes up but never comes down";
    
    /**
     * The '' request will display the list of client.
     *
     * @param request
     * @param response
     * @return	the administrator dashboard view
     * @throws Exception
     */
    @RequestMapping(value = "", method = RequestMethod.GET)
    public ModelAndView listHierarchy(HttpSession session) throws Exception {
       
        ModelAndView mav = new ModelAndView();
        mav.setViewName("/hierarchylist");
        
        User userDetails = (User) session.getAttribute("userDetails");
        
        if(orgHierarchyList == null) {
            orgHierarchyList = hierarchymanager.getProgramOrgHierarchy(programId);
        }
        
        mav.addObject("selectedId", orgHierarchyList.get(0).getId());
        mav.addObject("orgHierarchyList", orgHierarchyList);
        
        return mav;
    }
    
     /**
     * The 'gethierarchyItemList' GET request will return the list of the selected hierarchy items.
     * 
     * @param session
     * @param hierarchyId The id of the selected hierarchy
     * @return  The request will return the modifiedList view
     * @throws Exception 
     */
    @RequestMapping(value = "/gethierarchyItemList", method = RequestMethod.GET)
    @ResponseBody public ModelAndView gethierarchyItemList(@RequestParam(value = "hierarchyId", required = false) Integer hierarchyId, HttpSession session) throws Exception {
        
        ModelAndView mav = new ModelAndView();
        mav.setViewName("/hierarchy/itemlist");
        
        Integer id;
        String lastChar;
        String name = "";
        if(hierarchyId > 0 ) {
            id = hierarchyId;
            
            for(programOrgHierarchy hierarchy : orgHierarchyList) {
                if(hierarchy.getId() == hierarchyId) {
                    lastChar = hierarchy.getName().substring(hierarchy.getName().length()-1);
                    
                    if ("s".equals(lastChar)) {
                        name = hierarchy.getName().substring(0, hierarchy.getName().length()-1);
                    }
                    else {
                        name = hierarchy.getName();
                    }
                }
            }
        }
        else {
            id = orgHierarchyList.get(0).getId();
            lastChar = orgHierarchyList.get(0).getName().substring(orgHierarchyList.get(0).getName().length()-1);
            
            if ("s".equals(lastChar)) {
                name = orgHierarchyList.get(0).getName().substring(0, orgHierarchyList.get(0).getName().length()-1);
            }
            else {
                name = orgHierarchyList.get(0).getName();
            }
        }
        
        /* Get the list associated to the passed in hierarchy */
        List<programHierarchyDetails> hierarchyItems = hierarchymanager.getProgramHierarchyItems(id);
        mav.addObject("hierarchyItems", hierarchyItems);
        
        mav.addObject("selectedId", id);
        mav.addObject("hierarchyName", name);
        
        return mav;
        
    }
    
    /**
     * The 'getHierarchyItemDetails' GET request will return the details of the selected hierarchy
     * 
     * @param hierarchyId   The id of the clicked hierarchy
     * @param itemId    The id of the clicked hierarchy item
     * @param session
     * @return
     * @throws Exception 
     */
    @RequestMapping(value = "/getHierarchyItemDetails", method = RequestMethod.GET)
    @ResponseBody public ModelAndView getHierarchyItemDetails(@RequestParam(value = "hierarchyId", required = false) Integer hierarchyId, @RequestParam(value = "itemId", required = false) Integer itemId, HttpSession session) throws Exception {
        
        ModelAndView mav = new ModelAndView();
        mav.setViewName("/hierarchy/itemForm");
        mav.addObject("hierarchyId", hierarchyId);
        
        String name = "";
        String lastChar;
        Integer dspPos = 0;
        for(programOrgHierarchy hierarchy : orgHierarchyList) {
            if(hierarchy.getId() == hierarchyId) {
                lastChar = hierarchy.getName().substring(hierarchy.getName().length()-1);
                dspPos = hierarchy.getDspPos();
                if ("s".equals(lastChar)) {
                    name = hierarchy.getName().substring(0, hierarchy.getName().length()-1);
                }
                else {
                    name = hierarchy.getName();
                }
            }
        }
        
        programHierarchyDetails hierarchyDetails;
        String btnValue;
        if(itemId == 0) {
            hierarchyDetails = new programHierarchyDetails();
            hierarchyDetails.setProgramHierarchyId(hierarchyId);
            btnValue = "Create " + name;
        }
        else {
            hierarchyDetails = hierarchymanager.getProgramHierarchyItemDetails(itemId);
            hierarchyDetails.setAssociatedWith(hierarchymanager.getAssociatedHierarchy(itemId));
            btnValue = "Edit " + name;
        }
        
         //Get a list of states
        USStateList stateList = new USStateList();

        //Get the object that will hold the states
        mav.addObject("stateList", stateList.getStates());
       
        mav.addObject("hierarchyDetails",hierarchyDetails);
        mav.addObject("btnValue", btnValue);
        
        //Check to see if it is not the top level hierarchy
        if(dspPos > 1) {
            Integer parentHierarchy = dspPos--;
            
            /* Get a list of the parent hierarchy */
            programOrgHierarchy parent = hierarchymanager.getProgramOrgHierarchyBydspPos(dspPos, programId);
            
            List<programHierarchyDetails> parenthierarchyItems = hierarchymanager.getProgramHierarchyItems(parent.getId());
            mav.addObject("hierarchyItems", parenthierarchyItems);
            mav.addObject("parentHierarchy", parent.getName());
            
        }
        
        return mav;
    }
    
    
    /**
     * The '/saveHierarchyItem' POST request will handle submitting the hierarchyform.
     *
     * @param admindetails    The object containing the system administrator form fields
     * @param result        The validation result
     * @param redirectAttr	The variable that will hold values that can be read after the redirect
     *
     * @return	Will return the system administrators list page on "Save" Will return the system administrator form page on error
     
     * @throws Exception
     */
    @RequestMapping(value = "/saveHierarchyItem", method = RequestMethod.POST)
    public @ResponseBody
    ModelAndView saveAdmin(@Valid @ModelAttribute(value = "hierarchyDetails") programHierarchyDetails hierarchyDetails, BindingResult result, HttpSession session) throws Exception {

        if (result.hasErrors()) {
            ModelAndView mav = new ModelAndView();
            mav.setViewName("/hierarchy/itemForm");
            
            programOrgHierarchy hierarchy = hierarchymanager.getProgramOrgHierarchyById(hierarchyDetails.getProgramHierarchyId());
            
            String btnValue;
            if(hierarchyDetails.getId() > 0) {
                 btnValue = "Create " + hierarchy.getName();
            }
            else {
                btnValue = "Edit " + hierarchy.getName();
            }
            mav.addObject("btnValue", btnValue);
            return mav;
        }
       
        hierarchymanager.saveOrgHierarchyItem(hierarchyDetails);

        ModelAndView mav = new ModelAndView("/hierarchy/itemForm");
        
        
        if(hierarchyDetails.getId() > 0) {
            mav.addObject("success", "itemUpdated");
        }
        else {
           mav.addObject("success", "itemCreated");
        }
        
        return mav;
    }
    
    
    /**
     * The 'getProviders' GET request will return the list of providers.
     * 
     * @param session
     * @return  The request will return the list of providers 
     * @throws Exception 
     */
    @RequestMapping(value = "/getProviders", method = RequestMethod.GET)
    @ResponseBody public ModelAndView gethierarchyItemList(HttpSession session) throws Exception {
        
        ModelAndView mav = new ModelAndView();
        mav.setViewName("/hierarchy/providerList");
        
        /* Get the list associated to the passed in hierarchy */
        List<provider> providers = hierarchymanager.getProviders(programId);
        
        for(provider p : providers) {
            
            encryptObject encrypt = new encryptObject();
            Map<String,String> map;

            //Encrypt the use id to pass in the url
            map = new HashMap<String,String>();
            map.put("id",Integer.toString(p.getId()));
            map.put("topSecret",topSecret);

            String[] encrypted = encrypt.encryptObject(map);

            p.setEncryptedId(encrypted[0]);
            p.setEncryptedSecret(encrypted[1]);
            
        }
        
        mav.addObject("providers", providers);
        mav.addObject("page", "providers");
        
        return mav;
        
    }
    
    /**
     * The 'newProvider' GET request will return the details of the selected program
     * 
     * @param hierarchyId   The id of the clicked hierarchy
     * @param itemId    The id of the clicked hierarchy item
     * @param session
     * @return
     * @throws Exception 
     */
    @RequestMapping(value = "/newProvider", method = RequestMethod.GET)
    @ResponseBody public ModelAndView newProvider(HttpSession session) throws Exception {
        
        ModelAndView mav = new ModelAndView();
        mav.setViewName("/hierarchy/providerForm");
       
        provider providerDetails = new provider();
        providerDetails.setProgramId(programId);
       
         //Get a list of states
        USStateList stateList = new USStateList();

        //Get the object that will hold the states
        mav.addObject("stateList", stateList.getStates());
       
        mav.addObject("providerDetails",providerDetails);
        
        return mav;
    }
    
    /**
     * The '/saveNewProvider' POST request will handle submitting the new staff member.
     *
     * @param admindetails    The object containing the staff member form fields
     * @param result          The validation result
     * @param redirectAttr    The variable that will hold values that can be read after the redirect
     *
     * @return	Will send the program admin to the details of the new staff member
     
     * @throws Exception
     */
    @RequestMapping(value = "/saveNewProvider", method = RequestMethod.POST)
    public @ResponseBody ModelAndView saveNewProvider(@Valid @ModelAttribute(value = "providerDetails") provider providerDetails, BindingResult result, HttpSession session) throws Exception {

       
        if (result.hasErrors()) {
            ModelAndView mav = new ModelAndView();
            mav.setViewName("/hierarchy/providerForm");
            //Get a list of states
            USStateList stateList = new USStateList();

            //Get the object that will hold the states
            mav.addObject("stateList", stateList.getStates());
            
            return mav;
        }
        
        providerDetails.setProgramId(programId);
        Integer providerId = hierarchymanager.createProvider(providerDetails);
        
        Map<String,String> map = new HashMap<String,String>();
        map.put("id",Integer.toString(providerId));
        map.put("topSecret",topSecret);
        
        encryptObject encrypt = new encryptObject();

        String[] encrypted = encrypt.encryptObject(map);
        
        ModelAndView mav = new ModelAndView();
        mav.setViewName("/hierarchy/providerForm");
        mav.addObject("encryptedURL", "?i="+encrypted[0]+"&v="+encrypted[1]);
        return mav;

    }
    
    /**
     * The '/provider/details' GET request will return the details of the selected provider
     * 
     * @param providerId   The id of the clicked provider
     * @param session
     * @return
     * @throws Exception 
     */
    @RequestMapping(value = "/provider/details", method = RequestMethod.GET)
    @ResponseBody public ModelAndView getProviderDetails(@RequestParam String i, @RequestParam String v, HttpSession session) throws Exception {
        
        ModelAndView mav = new ModelAndView();
        mav.setViewName("/providerDetails");
        
        /* Decrypt the url */
        decryptObject decrypt = new decryptObject();
        
        Object obj = decrypt.decryptObject(i, v);
        
        String[] result = obj.toString().split((","));
        
        int providerId = Integer.parseInt(result[0].substring(4));
        mav.addObject("providerId", providerId);
       
        provider providerDetails = hierarchymanager.getProviderDetails(providerId);
        
        
         //Get a list of states
        USStateList stateList = new USStateList();

        //Get the object that will hold the states
        mav.addObject("stateList", stateList.getStates());
       
        mav.addObject("providerDetails",providerDetails);
        
         if(orgHierarchyList == null) {
            orgHierarchyList = hierarchymanager.getProgramOrgHierarchy(programId);
        }
        
        mav.addObject("orgHierarchyList", orgHierarchyList);
        mav.addObject("page","providerDetails");
        mav.addObject("hierarchyName", "Edit Provider");
        
        // Get a list of associated hierarchy items
        Integer lastHierarchyId = 0;
        
        for(programOrgHierarchy hierarchy : orgHierarchyList) {
            lastHierarchyId = hierarchy.getId();
        }
          
        programOrgHierarchy assocHierarchy = hierarchymanager.getOrgHierarchyById(lastHierarchyId);
        mav.addObject("assocHierarchyName", assocHierarchy.getName());
        
        
        return mav;
    }
    
    /**
     * 
     * @param providerId
     * @param session
     * @return
     * @throws Exception 
     */
    @RequestMapping(value = "/getExistingProviderAssocItems", method = RequestMethod.GET)
    @ResponseBody public ModelAndView getExistingProviderAssocItems(@RequestParam Integer providerId, HttpSession session) throws Exception {
        
        ModelAndView mav = new ModelAndView();
        mav.setViewName("/hierarchy/providerAssocItems");
        
        // Get a list of associated hierarchy items
        Integer lastHierarchyId = 0;
        
        for(programOrgHierarchy hierarchy : orgHierarchyList) {
            lastHierarchyId = hierarchy.getId();
        }
          
        programOrgHierarchy assocHierarchy = hierarchymanager.getOrgHierarchyById(lastHierarchyId);
        mav.addObject("assocHierarchyName", assocHierarchy.getName());
        
        List<providerHierarchyAssoc> associatedHierarchy = hierarchymanager.getProviderAssociatedHierarchy(providerId);
        
        for(providerHierarchyAssoc item : associatedHierarchy) {
            item.setAssocName(hierarchymanager.getProgramHierarchyItemDetails(item.getHierarchyDetailId()).getName());
        }
        mav.addObject("associatedItems", associatedHierarchy);
        
        return mav;
    }
    
    
    /**
     * The '/provider/details' POST request will submit the provider details form
     * 
     * @param i The encrypted url value containing the selected provider id
     * @param v The encrypted url value containing the secret decode key
     * @return
     * @throws Exception 
     */
    @RequestMapping(value = "/provider/details", method = RequestMethod.POST)
    public ModelAndView saveProviderDetails(@ModelAttribute(value = "providerDetails") provider providerDetails, HttpSession session, 
            RedirectAttributes redirectAttr, @RequestParam String action, @RequestParam String i, @RequestParam String v) throws Exception {
        
        /* Decrypt the url */
        decryptObject decrypt = new decryptObject();
        
        Object obj = decrypt.decryptObject(i, v);
        
        String[] result = obj.toString().split((","));
        
        int providerId = Integer.parseInt(result[0].substring(4));
        
        providerDetails.setId(providerId);
        
        hierarchymanager.updateProvider(providerDetails);
        
        if (action.equals("save")) {
            redirectAttr.addFlashAttribute("savedStatus", "updated");
            ModelAndView mav = new ModelAndView(new RedirectView("/hierarchy/provider/details?i="+URLEncoder.encode(i,"UTF-8")+"&v="+URLEncoder.encode(v,"UTF-8")));
            return mav;
        } else {
            ModelAndView mav = new ModelAndView(new RedirectView("/hierarchy?msg=providerupdated"));
            return mav;
        }
        
    }
    
    
    /**
     * The 'getProviderAssocItems' GET request will return the list of associated items for the selected provider.
     * 
     * @param providerId    The selected provider Id
     * @param session
     * @return
     * @throws Exception 
     */
    @RequestMapping(value = "/getProviderAssocItems", method = RequestMethod.GET)
    @ResponseBody public ModelAndView getProviderAssocItems(@RequestParam Integer providerId, HttpSession session) throws Exception {
        
        ModelAndView mav = new ModelAndView();
        mav.setViewName("/hierarchy/hierarchyAssocForm");
        
        // Get a list of associated hierarchy items
        Integer lastHierarchyId = 0;
        
        for(programOrgHierarchy hierarchy : orgHierarchyList) {
            lastHierarchyId = hierarchy.getId();
        }
        programOrgHierarchy assocHierarchy = hierarchymanager.getOrgHierarchyById(lastHierarchyId);
        mav.addObject("assocHierarchyName", assocHierarchy.getName());
        
        List<programHierarchyDetails> parenthierarchyItems = hierarchymanager.getProgramHierarchyItems(lastHierarchyId);
        
        List<providerHierarchyAssoc> associatedHierarchy = hierarchymanager.getProviderAssociatedHierarchy(providerId);
        
        List<programHierarchyDetails> availableItems = new ArrayList<programHierarchyDetails>();
        for(programHierarchyDetails detail : parenthierarchyItems) {
            
            boolean used = false;
            
            for(providerHierarchyAssoc item : associatedHierarchy) {
                
                if(detail.getId() == item.getHierarchyDetailId()) {
                    used = true;
                }
            }
            
            if(used == false) {
                availableItems.add(detail);
            }
        }
        
        mav.addObject("availableItems", availableItems);
        
        return mav;
        
    }
    
    /**
     * The 'saveProviderAssocItem' POST request will save the selected item for the selected provider.
     */
    @RequestMapping(value = "/saveProviderAssocItem", method = RequestMethod.POST)
    @ResponseBody public ModelAndView saveProviderAssocItem(@RequestParam Integer providerId, @RequestParam List<String> items, HttpSession session) throws Exception {
        
        ModelAndView mav = new ModelAndView("/hierarchy/hierarchyAssocForm");
        
        if(items != null && !items.isEmpty()) {
            
            for(String item : items) {
                if(item != "null") {
                     providerHierarchyAssoc newAssoc = new providerHierarchyAssoc();
                    newAssoc.setProviderId(providerId);
                    newAssoc.setHierarchyDetailId(Integer.parseInt(item.replace("'", "")));

                    hierarchymanager.saveProviderHierarchyAssoc(newAssoc);
                }
            }
        }
       
        mav.addObject("success", "itemAssociated");
        
        return mav;
        
    }
    
    
    /**
     * The 'removeProviderAssocItem' POST request will remove the selected item for the selected provider.
     * 
     * @param providerId    The selected providerId
     * @param itemId    The selected ItemId
     * @param session
     * @return
     * @throws Exception 
     */
    @RequestMapping(value = "/removeProviderAssocItem", method = RequestMethod.POST)
    @ResponseBody public Integer removeProviderAssocItem(@RequestParam Integer itemId, HttpSession session) throws Exception {
        
        hierarchymanager.removeProviderHierarchyAssoc(itemId);
        
        return 1;
    }
    
    /**
     * The 'getAvailableServices' GET request will return the list of services not yet associated to this provider.
     * 
     * @param providerId    The selected provider Id
     * @param session
     * @return
     * @throws Exception 
     */
    @RequestMapping(value = "/getAvailableServices", method = RequestMethod.GET)
    @ResponseBody public ModelAndView getAvailableServices(@RequestParam Integer providerId, HttpSession session) throws Exception {
        
        ModelAndView mav = new ModelAndView();
        mav.setViewName("/hierarchy/serviceAssocForm");
        
        List<programServices> availableServices = servicemanager.getProgramServices(programId, providerId);
        
        mav.addObject("availableServices", availableServices);
        mav.addObject("providerId", providerId);
        
        return mav;
        
    }
    
    /**
     * The 'saveProviderServices' POST request will save the selected services for the selected provider.
     */
    @RequestMapping(value = "/saveProviderServices", method = RequestMethod.POST)
    @ResponseBody public ModelAndView saveProviderServices(@RequestParam Integer providerId, @RequestParam(value = "selItems", required = false) List<Integer> services, HttpSession session) throws Exception {
        
        ModelAndView mav = new ModelAndView("/hierarchy/serviceAssocForm");
        
        if(services != null && !services.isEmpty()) {
            
            for(Integer service : services) {
                providerServices newAssoc = new providerServices();
                newAssoc.setProviderId(providerId);
                newAssoc.setProgramId(programId);
                newAssoc.setServiceId(service);

                servicemanager.saveProviderService(newAssoc);
            }
        }
       
        mav.addObject("success", "itemAssociated");
        
        return mav;
        
    }
    
    /**
     * The 'getExistingProviderServices' GET request will return the list of associated services for the selected provider.
     * 
     * @param providerId    The selected provider Id
     * @param session
     * @return
     * @throws Exception 
     */
    @RequestMapping(value = "/getExistingProviderServices", method = RequestMethod.GET)
    @ResponseBody public ModelAndView getExistingProviderServices(@RequestParam Integer providerId, HttpSession session) throws Exception {
        
        ModelAndView mav = new ModelAndView();
        mav.setViewName("/hierarchy/providerServices");
        
        List<programServices> services = servicemanager.getProviderServices(programId, providerId);
        
        mav.addObject("services", services);
        return mav;
        
    }
    
    /**
     * The 'removeProviderService' POST request will remove the selected service for the selected provider.
     * 
     * @param providerId    The selected providerId
     * @param serviceId    The selected ItemId
     * @param session
     * @return
     * @throws Exception 
     */
    @RequestMapping(value = "/removeProviderService", method = RequestMethod.POST)
    @ResponseBody public Integer removeProviderService(@RequestParam Integer serviceId, @RequestParam Integer providerId, HttpSession session) throws Exception {
        
        servicemanager.removeProviderService(programId, serviceId, providerId);
        
        return 1;
    }
    
    
}
