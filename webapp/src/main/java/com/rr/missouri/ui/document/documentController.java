/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.rr.missouri.ui.document;

import com.registryKit.document.document;
import com.registryKit.document.documentEmailNotifications;
import com.registryKit.document.documentFolder;
import com.registryKit.document.documentManager;
import com.registryKit.document.documentNotificationPreferences;
import com.registryKit.hierarchy.hierarchyManager;
import com.registryKit.hierarchy.programHierarchyDetails;
import com.registryKit.hierarchy.programOrgHierarchy;
import com.registryKit.user.User;
import com.registryKit.user.userManager;
import com.rr.missouri.ui.security.decryptObject;
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
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;
import com.registryKit.user.userProgramModules;
import java.net.URLEncoder;
import javax.servlet.http.HttpServletRequest;
import org.springframework.http.MediaType;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import org.springframework.web.servlet.view.RedirectView;

/**
 *
 * @author chadmccue
 */
@Controller
@RequestMapping("/documents")
public class documentController {

    private static final Integer moduleId = 10;

    @Autowired
    private userManager usermanager;

    @Autowired
    private documentManager documentmanager;

    @Autowired
    private hierarchyManager hierarchymanager;

    @Value("${programId}")
    private Integer programId;

    @Value("${topSecret}")
    private String topSecret;

    private static List<documentFolder> folders;
    private static Integer selFolder = 0;

    private static boolean allowCreate = false;
    private static boolean allowEdit = false;
    private static boolean allowDelete = false;

    /**
     * The '' request will display the list of taken surveys.
     *
     * @param session
     * @return	the administrator dashboard view
     * @throws Exception
     */
    @RequestMapping(value = "", method = RequestMethod.GET)
    public ModelAndView listDocuments(HttpSession session) throws Exception {

        ModelAndView mav = new ModelAndView();
        mav.setViewName("/documents");

        /* Get a list of completed surveys the logged in user has access to */
        User userDetails = (User) session.getAttribute("userDetails");

        /* Get a list of folders  */
        List<documentFolder> folderList = documentmanager.getFolders(programId, userDetails);

        encryptObject encrypt = new encryptObject();
        Map<String, String> map;

        for (documentFolder folder : folderList) {
            //Encrypt the use id to pass in the url
            map = new HashMap<String, String>();
            map.put("id", Integer.toString(folder.getId()));
            map.put("topSecret", topSecret);

            String[] encrypted = encrypt.encryptObject(map);

            folder.setEncryptedId(encrypted[0]);
            folder.setEncryptedSecret(encrypted[1]);

        }

        folders = folderList;
        mav.addObject("folders", folders);

        List<documentFolder> subfolderList = documentmanager.getSubFolders(programId, userDetails, folderList.get(0).getId());

        if (subfolderList != null && subfolderList.size() > 0) {

            for (documentFolder subfolder : subfolderList) {
                //Encrypt the use id to pass in the url
                map = new HashMap<String, String>();
                map.put("id", Integer.toString(subfolder.getId()));
                map.put("topSecret", topSecret);

                String[] encrypted = encrypt.encryptObject(map);

                subfolder.setEncryptedId(encrypted[0]);
                subfolder.setEncryptedSecret(encrypted[1]);

            }

            mav.addObject("subfolders", subfolderList);
        }
        
        selFolder = folderList.get(0).getId();
        mav.addObject("selFolder", selFolder);
        mav.addObject("selParentFolder", folderList.get(0).getParentFolderId());
        mav.addObject("selFolderName", folderList.get(0).getFolderName());
        mav.addObject("selFolderNameEncoded", URLEncoder.encode(folderList.get(0).getFolderName(),"UTF-8"));
        
        /* Get Documents for the folder */
        List<document> documents = documentmanager.getFolderDocuments(programId, userDetails, folderList.get(0).getId());
        
        if(documents != null && documents.size() > 0) {
            for(document doc : documents) {
                if(doc.getUploadedFile() != null && !"".equals(doc.getUploadedFile())) {
                    int index = doc.getUploadedFile().lastIndexOf('.');
                    doc.setFileExt(doc.getUploadedFile().substring(index+1));
                }
                User createdBy = usermanager.getUserById(doc.getSystemUserId());
                doc.setCreatedBy(createdBy.getFirstName() + " " + createdBy.getLastName());
            } 
        }
        
        mav.addObject("documents", documents);

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
        return mav;
    }

    /**
     * The '/folder' GET request will return the list of
     * subfolders and documents for the clicked folder.
     *
     * @param i
     * @param v
     * @param session
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/folder", method = RequestMethod.GET)
    public ModelAndView listFolderDocuments(@RequestParam String i, @RequestParam String v, HttpSession session) throws Exception {

        ModelAndView mav = new ModelAndView();
        mav.setViewName("/documents");

        /* Get a list of completed surveys the logged in user has access to */
        User userDetails = (User) session.getAttribute("userDetails");

        /* Decrypt the url */
        decryptObject decrypt = new decryptObject();

        Object obj = decrypt.decryptObject(i, v);

        String[] result = obj.toString().split((","));

        int clickedFolderId = Integer.parseInt(result[0].substring(4));
        
        documentFolder folderDetails = documentmanager.getFolderById(clickedFolderId);

        /* Get a list of folders  */
        Integer mainFolderId = 0;
        if (folderDetails.getParentFolderId() > 0) {
            mainFolderId = folderDetails.getParentFolderId();
            
            documentFolder parent = documentmanager.getFolderById(folderDetails.getParentFolderId());
            mav.addObject("selParentFolderName", parent.getFolderName());
                        
            //need to encrypt parent folder here
            encryptObject encryptParent = new encryptObject();
            Map<String, String> mapParent;
            mapParent = new HashMap<String, String>();
            mapParent.put("id", String.valueOf(parent.getId()));
            mapParent.put("topSecret", topSecret);
            String[] encryptedParent = encryptParent.encryptObject(mapParent);
            parent.setEncryptedId(encryptedParent[0]);
            parent.setEncryptedSecret(encryptedParent[1]);
            mav.addObject("parentFolder", parent);   
        } else {
            mainFolderId = folderDetails.getId();
        }
        
        List<documentFolder> subfolderList = documentmanager.getSubFolders(programId, userDetails, mainFolderId);

        if (subfolderList != null && subfolderList.size() > 0) {

            encryptObject encrypt = new encryptObject();
            Map<String, String> map;

            for (documentFolder folder : subfolderList) {
                //Encrypt the use id to pass in the url
                map = new HashMap<String, String>();
                map.put("id", Integer.toString(folder.getId()));
                map.put("topSecret", topSecret);

                String[] encrypted = encrypt.encryptObject(map);

                folder.setEncryptedId(encrypted[0]);
                folder.setEncryptedSecret(encrypted[1]);

            }

            mav.addObject("subfolders", subfolderList);
        }
        
        /* Get Documents for the folder */
        List<document> documents = documentmanager.getFolderDocuments(programId, userDetails, folderDetails.getId());
        
        if(documents != null && documents.size() > 0) {
            for(document doc : documents) {
                if(doc.getUploadedFile() != null && !"".equals(doc.getUploadedFile())) {
                    int index = doc.getUploadedFile().lastIndexOf('.');
                    doc.setFileExt(doc.getUploadedFile().substring(index+1));
                }
                User createdBy = usermanager.getUserById(doc.getSystemUserId());
                doc.setCreatedBy(createdBy.getFirstName() + " " + createdBy.getLastName());
            } 
        }
        
        mav.addObject("documents", documents);

        mav.addObject("folders", folders);
        
        selFolder = folderDetails.getId();
        mav.addObject("selFolder", selFolder);
        mav.addObject("selParentFolder", folderDetails.getParentFolderId());
        mav.addObject("selFolderName", folderDetails.getFolderName());
        mav.addObject("selFolderNameEncoded", URLEncoder.encode(folderDetails.getFolderName(),"UTF-8"));
        
        mav.addObject("allowCreate", allowCreate);
        mav.addObject("allowEdit", allowEdit);
        mav.addObject("allowDelete", allowDelete);
        
        return mav;

    }
    
    /**
     * The '/document/getFolderForm.do' GET request will return the details for the selected/new folder 
     * form.
     *
     * @param session
     * @param subfolder
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/getFolderForm.do", method = RequestMethod.GET)
    public @ResponseBody
    ModelAndView getFolderForm(HttpSession session, @RequestParam(value = "subfolder", required = true) Boolean subfolder) throws Exception {

        ModelAndView mav = new ModelAndView();
        mav.setViewName("/document/folderForm");
        
        /* Get a list of completed surveys the logged in user has access to */
        User userDetails = (User) session.getAttribute("userDetails");

        documentFolder newFolder = new documentFolder();
        newFolder.setSystemUserId(userDetails.getId());
        
        if(subfolder == true && selFolder > 0) {
            documentFolder parentFolderDetails = documentmanager.getFolderById(selFolder);
            newFolder.setParentFolderId(selFolder);
            newFolder.setCountyFolder(parentFolderDetails.getCountyFolder());
            newFolder.setEntityId(parentFolderDetails.getEntityId());
        }
        
        if (userDetails.getRoleId() == 2) {
            programOrgHierarchy topLevel = hierarchymanager.getProgramOrgHierarchyBydspPos(1, programId);
            List<programHierarchyDetails> counties = hierarchymanager.getProgramHierarchyItems(topLevel.getId(), 0);
           mav.addObject("countyList", counties);
        
        }
        
        mav.addObject("folderDetails", newFolder);

        return mav;
    }
    
    /**
     * The 'saveFolderForm' POST request will handle saving the new/updated document
     * message.
     *
     * @param folderDetails
     * @param redirectAttr
     * @param session
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/saveFolderForm.do", method = RequestMethod.POST)
    public @ResponseBody
    ModelAndView saveFolderForm(@ModelAttribute(value = "folderDetails") documentFolder folderDetails, RedirectAttributes redirectAttr,
            HttpSession session) throws Exception {

        /* Get a list of completed surveys the logged in user has access to */
        User userDetails = (User) session.getAttribute("userDetails");

        folderDetails.setProgramId(programId);
        
        Integer folderId = documentmanager.saveFolder(folderDetails);

        documentFolder folder = documentmanager.getFolderById(folderId);
        
        encryptObject encrypt = new encryptObject();
        Map<String, String> map;
        
        map = new HashMap<String, String>();
        map.put("id", Integer.toString(folder.getId()));
        map.put("topSecret", topSecret);

        String[] encrypted = encrypt.encryptObject(map);
        
        /* Get a list of folders  */
        List<documentFolder> folderList = documentmanager.getFolders(programId, userDetails);

        for (documentFolder fldr : folderList) {
            //Encrypt the use id to pass in the url
            map = new HashMap<String, String>();
            map.put("id", Integer.toString(fldr.getId()));
            map.put("topSecret", topSecret);

            String[] encrypted2 = encrypt.encryptObject(map);

            fldr.setEncryptedId(encrypted2[0]);
            fldr.setEncryptedSecret(encrypted2[1]);
        }

        folders = folderList;
       
        ModelAndView mav = new ModelAndView(new RedirectView("/documents/folder?i=" + encrypted[0] + "&v=" + encrypted[1]));
        
        return mav;

    }
    
    
    /**
     * The '/document/getDocumentForm.do' GET request will return the details for the selected/new document 
     * form.
     *
     * @param session
     * @param documentId (required) The id of the selected document
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/getDocumentForm.do", method = RequestMethod.GET)
    public @ResponseBody
    ModelAndView getTopicForm(HttpSession session, @RequestParam(value = "documentId", required = true) Integer documentId) throws Exception {

        ModelAndView mav = new ModelAndView();
        mav.setViewName("/document/documentForm");
        
        /* Get a list of completed surveys the logged in user has access to */
        User userDetails = (User) session.getAttribute("userDetails");

        document documentDetails;
        
        documentFolder folderDetails = documentmanager.getFolderById(selFolder);
        
        if (documentId == 0) {
            documentDetails = new document();
            documentDetails.setFolderId(selFolder);
            documentDetails.setSystemUserId(userDetails.getId());
            documentDetails.setCountyFolder(folderDetails.getCountyFolder());
            
        } else {
            documentDetails = documentmanager.getDocumentById(documentId);
            
            if(documentDetails.getUploadedFile() != null && !"".equals(documentDetails.getUploadedFile())) {
                int index = documentDetails.getUploadedFile().lastIndexOf('.');
                documentDetails.setFileExt(documentDetails.getUploadedFile().substring(index+1));
            }
            
        }
        
        if(userDetails.getRoleId() != 3) {
            for(documentFolder folder : folders) {
                List<documentFolder> folderSubfolders = documentmanager.getSubFolders(programId, userDetails, folder.getId());
                
                if(folderSubfolders != null && folderSubfolders.size() > 0) {
                    folder.setSubfolders(folderSubfolders);
                }
            }
            mav.addObject("documentfolder", folders);
        }
        
        mav.addObject("documentDetails", documentDetails);

        return mav;
    }
    
    /**
     * The 'saveDocuemntForm' POST request will handle saving the new/updated document
     * message.
     *
     * @param documentDetails
     * @param postDocuments
     * @param redirectAttr
     * @param session
     * @param alertUsers
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/saveDocuemntForm.do", method = RequestMethod.POST)
    public @ResponseBody
    ModelAndView savePostForm(@ModelAttribute(value = "documentDetails") document documentDetails,
            @RequestParam(value = "postDocuments", required = false) List<MultipartFile> postDocuments, RedirectAttributes redirectAttr,
            HttpSession session, @RequestParam(value = "alertUsers", required = false, defaultValue = "0") Integer alertUsers) throws Exception {

        /* Get a list of completed surveys the logged in user has access to */
        User userDetails = (User) session.getAttribute("userDetails");

        documentDetails.setProgramId(programId);
        
        Integer documentId = documentDetails.getId();
        
        
        /* Check to see if the file has moved folders */
        document currDocDetails = documentmanager.getDocumentById(documentDetails.getId());
        
        String newFileNameFromMove = "";
        if(currDocDetails != null && currDocDetails.getFolderId() != documentDetails.getFolderId() && !"".equals(currDocDetails.getUploadedFile())) {
            /* Need to find the document and move it to the new folder */
            newFileNameFromMove = documentmanager.moveDocumentFile(programId, currDocDetails.getFolderId(), documentDetails.getFolderId(), currDocDetails.getUploadedFile());
        }
        
        if(!"".equals(newFileNameFromMove)) {
            documentDetails.setUploadedFile(newFileNameFromMove);
        }
        
        documentFolder folderDetails  = documentmanager.getFolderById(documentDetails.getFolderId());
        if (folderDetails.getAdminOnly()) {
            documentDetails.setAdminOnly(true);
        }
        
        documentmanager.saveDocument(documentDetails);
        
        
        if (postDocuments != null) {
            documentmanager.saveUploadedDocument(documentDetails, postDocuments);
        }

        encryptObject encrypt = new encryptObject();
        Map<String, String> map;
        
        map = new HashMap<String, String>();
        map.put("id", Integer.toString(folderDetails.getId()));
        map.put("topSecret", topSecret);

        String[] encrypted = encrypt.encryptObject(map);
        
        /* Alert Users, we only alert if new document and not private doc  */
        if(alertUsers > 0 && documentId == 0 && !documentDetails.getPrivateDoc()) {
            
            /* County Users */
            if(alertUsers == 1 ) { //new document
                documentEmailNotifications emailNotification = new documentEmailNotifications();
                emailNotification.setProgramId(programId);
                emailNotification.setNotificationType(1); //docs for user in hierarchy
                emailNotification.setDocumentId(documentDetails.getId());
                documentmanager.saveEmailNotification(emailNotification);
            }
            /* All Users, new document, not private */
            else if (alertUsers == 2){
                documentEmailNotifications emailNotification = new documentEmailNotifications();
                emailNotification.setProgramId(programId);
                emailNotification.setNotificationType(2); //docs for user in hierarchy
                emailNotification.setDocumentId(documentDetails.getId());
                documentmanager.saveEmailNotification(emailNotification);   
            }  
        }

        ModelAndView mav = new ModelAndView(new RedirectView("/documents/folder?i=" + encrypted[0] + "&v=" + encrypted[1]));
        return mav;

    }
    
    /**
     * The 'deleteDocument' POST request will remove the clicked uploaded
     * document.
     *
     * @param documentId The id of the clicked document.
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/deleteDocument.do", method = RequestMethod.POST)
    public @ResponseBody
    Integer deleteDocument(@RequestParam(value = "documentId", required = true) Integer documentId) throws Exception {
        
        document documentDetails = documentmanager.getDocumentById(documentId);
        documentDetails.setStatus(false);
        documentmanager.saveDocument(documentDetails);
        documentmanager.updateEmailNotificationByDocumentId(documentDetails.getId(), 0);
        return 1;
    }
    
    @RequestMapping(value = "/getDocumentNotificationModel.do", method = RequestMethod.GET)
    public ModelAndView getDocumentNotificationModel(HttpSession session, HttpServletRequest request) throws Exception {

        ModelAndView mav = new ModelAndView();
        mav.setViewName("/document/documentNotificationPreferences");

        User userDetails = (User) session.getAttribute("userDetails");

        documentNotificationPreferences notificationPreferences = documentmanager.getNotificationPreferences(userDetails.getId());

        if (notificationPreferences != null) {
            mav.addObject("notificationPreferences", notificationPreferences);
        } else {
            documentNotificationPreferences newNotificationPreferences = new documentNotificationPreferences();
            newNotificationPreferences.setNotificationEmail(userDetails.getEmail());
            newNotificationPreferences.setProgramId(programId);
            mav.addObject("notificationPreferences", newNotificationPreferences);
        }
        
        return mav;
    }
    
    
    @RequestMapping(value = "/saveNotificationPreferences.do", method = RequestMethod.POST)
    public @ResponseBody
    Integer saveNotificationPreferences(@ModelAttribute(value = "notificationPreferences") documentNotificationPreferences notificationPreferences, BindingResult errors,
            HttpSession session, HttpServletRequest request) throws Exception {
        
        User userDetails = (User) session.getAttribute("userDetails");

        notificationPreferences.setSystemUserId(userDetails.getId());

        documentmanager.saveNotificationPreferences(notificationPreferences);

        return 1;

    }
    
    @RequestMapping(value = "/checkFolderName.do", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
    public @ResponseBody
    Integer checkFolderName (@RequestParam(value = "folderId", required = true) Integer folderId,
            @RequestParam(value = "folderName", required = true) String folderName,
            @RequestParam(value = "parentFolderId", required = true) Integer parentFolderId,
            HttpSession session, HttpServletRequest request) throws Exception {
        
        documentFolder folder = documentmanager.getFolderByNameIncParent(programId, folderName, parentFolderId);
        
        if (folder.getId() != folderId) {
            if (folder.getId() != 0) {
                return 1;
            }
        }
        
       return 0;

    }
}
