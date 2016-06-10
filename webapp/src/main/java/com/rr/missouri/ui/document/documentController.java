/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.rr.missouri.ui.document;

import com.registryKit.document.document;
import com.registryKit.document.documentEmailNotifications;
import com.registryKit.document.documentFile;
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
import java.text.SimpleDateFormat;
import java.util.Date;
import javax.servlet.http.HttpServletRequest;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
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
    
    @Value("${programName}")
    private String programName;

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
        mav.setViewName("/documentSearch");

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
         
        mav.addObject("savedSearchString", session.getAttribute("searchString"));
        mav.addObject("savedadminOnly", session.getAttribute("adminOnly"));
        mav.addObject("savedstartSearchDate", session.getAttribute("startSearchDate"));
        mav.addObject("savedendSearchDate", session.getAttribute("endSearchDate"));
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
        
        String downloadLink = "";
        Integer folderCount = 1;

        /* Get a list of folders  */
        Integer parentFolderId = 0;
        Integer getSubFoldersFor = 0;
        Integer getSubSubFoldersFor = 0;
        if (folderDetails.getParentFolderId() > 0) {
            folderCount+=1;
            
            parentFolderId = folderDetails.getParentFolderId();
            
            documentFolder parentFolderDetails = documentmanager.getFolderById(parentFolderId);
            
            if(parentFolderDetails.getParentFolderId() > 0) {
                folderCount+=1;
                
                getSubFoldersFor = parentFolderDetails.getParentFolderId();
                getSubSubFoldersFor = folderDetails.getParentFolderId();
                
                documentFolder superParentFolderDetails = documentmanager.getFolderById(parentFolderDetails.getParentFolderId());
                
                 mav.addObject("selSuperParentFolderName", superParentFolderDetails.getFolderName());
                 
                 //need to encrypt parent folder here
                encryptObject encryptParent = new encryptObject();
                Map<String, String> mapParent;
                mapParent = new HashMap<String, String>();
                mapParent.put("id", String.valueOf(superParentFolderDetails.getId()));
                mapParent.put("topSecret", topSecret);
                String[] encryptedParent = encryptParent.encryptObject(mapParent);
                superParentFolderDetails.setEncryptedId(encryptedParent[0]);
                superParentFolderDetails.setEncryptedSecret(encryptedParent[1]);
                mav.addObject("superParentFolder", superParentFolderDetails); 
                
                downloadLink = superParentFolderDetails.getFolderName()+"/";
            }
            else {
                getSubFoldersFor = folderDetails.getParentFolderId();
                getSubSubFoldersFor = clickedFolderId;
            }
            
            mav.addObject("selParentFolderName", parentFolderDetails.getFolderName());
                        
            //need to encrypt parent folder here
            encryptObject encryptParent = new encryptObject();
            Map<String, String> mapParent;
            mapParent = new HashMap<String, String>();
            mapParent.put("id", String.valueOf(parentFolderDetails.getId()));
            mapParent.put("topSecret", topSecret);
            String[] encryptedParent = encryptParent.encryptObject(mapParent);
            parentFolderDetails.setEncryptedId(encryptedParent[0]);
            parentFolderDetails.setEncryptedSecret(encryptedParent[1]);
            mav.addObject("parentFolder", parentFolderDetails);  
            
            downloadLink += parentFolderDetails.getFolderName()+"/"+folderDetails.getFolderName();
            
            
        } else {
            getSubFoldersFor = folderDetails.getId();
            parentFolderId = folderDetails.getId();
            downloadLink = folderDetails.getFolderName();
        }
        
        if(getSubFoldersFor > 0) {
            List<documentFolder> subfolderList = documentmanager.getSubFolders(programId, userDetails, getSubFoldersFor);

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
        }
        
        if(getSubSubFoldersFor > 0) {
            List<documentFolder> subsubfolderList = documentmanager.getSubFolders(programId, userDetails, getSubSubFoldersFor);

            if (subsubfolderList != null && subsubfolderList.size() > 0) {

                encryptObject encrypt = new encryptObject();
                Map<String, String> map;

                for (documentFolder folder : subsubfolderList) {
                    //Encrypt the use id to pass in the url
                    map = new HashMap<String, String>();
                    map.put("id", Integer.toString(folder.getId()));
                    map.put("topSecret", topSecret);

                    String[] encrypted = encrypt.encryptObject(map);

                    folder.setEncryptedId(encrypted[0]);
                    folder.setEncryptedSecret(encrypted[1]);

                }

                mav.addObject("subsubfolders", subsubfolderList);
            }
        }
        
        /* Get Documents for the folder */
        List<document> documents = documentmanager.getFolderDocuments(programId, userDetails, folderDetails.getId());
        
        if(documents != null && documents.size() > 0) {
            for(document doc : documents) {
                if(doc.getTotalFiles() == 1 && (doc.getFoundFile() != null && !"".equals(doc.getFoundFile()))) {
                    int index = doc.getFoundFile().lastIndexOf('.');
                    doc.setFileExt(doc.getFoundFile().substring(index+1));
                    
                    String encodedFileName = URLEncoder.encode(doc.getFoundFile(),"UTF-8");
                    doc.setUploadedFile(encodedFileName);

                    doc.setDownloadLink(URLEncoder.encode(downloadLink,"UTF-8"));
                }
                User createdBy = usermanager.getUserById(doc.getSystemUserId());
                doc.setCreatedBy(createdBy.getFirstName() + " " + createdBy.getLastName());
                
            } 
        }
        
        mav.addObject("documents", documents);

        mav.addObject("folders", folders);
        mav.addObject("folderCount", folderCount);
        
        selFolder = folderDetails.getId();
        mav.addObject("selFolder", selFolder);
        mav.addObject("selParentFolder", folderDetails.getParentFolderId());
        mav.addObject("selFolderName", folderDetails.getFolderName());
        mav.addObject("selFolderNameEncoded", URLEncoder.encode(folderDetails.getFolderName(),"UTF-8"));
        mav.addObject("readOnly", folderDetails.getReadOnly());
        
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
    ModelAndView getFolderForm(HttpSession session, @RequestParam(value = "editFolder", required = true) Boolean editFolder, @RequestParam(value = "subfolder", required = true) Boolean subfolder) throws Exception {

        ModelAndView mav = new ModelAndView();
        mav.setViewName("/document/folderForm");
        
        /* Get a list of completed surveys the logged in user has access to */
        User userDetails = (User) session.getAttribute("userDetails");
        
        documentFolder folderDetails;

        if(editFolder == true) {
            folderDetails = documentmanager.getFolderById(selFolder);
            folderDetails.setSystemUserId(userDetails.getId());
            folderDetails.setCurrentFolderName(folderDetails.getFolderName());
        }
        else {
            folderDetails = new documentFolder();
            folderDetails.setSystemUserId(userDetails.getId());
            
            if(subfolder == true && selFolder > 0) {
                documentFolder parentFolderDetails = documentmanager.getFolderById(selFolder);
                folderDetails.setParentFolderId(selFolder);
                folderDetails.setCountyFolder(parentFolderDetails.getCountyFolder());
                folderDetails.setEntityId(parentFolderDetails.getEntityId());
            }
        }
        
        if (userDetails.getRoleId() == 2) {
            programOrgHierarchy topLevel = hierarchymanager.getProgramOrgHierarchyBydspPos(1, programId);
            List<programHierarchyDetails> counties = hierarchymanager.getProgramHierarchyItems(topLevel.getId(), 0);
            mav.addObject("countyList", counties);
        }
        
        mav.addObject("folderDetails", folderDetails);

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

        encryptObject encrypt = new encryptObject();
        Map<String, String> map;
        
        map = new HashMap<String, String>();
        map.put("id", Integer.toString(folderId));
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
            
             List<documentFile> documentFiles = documentmanager.getDocumentFiles(documentId);
            
            if(documentFiles != null) {
                for(documentFile document : documentFiles) {
                    int index = document.getUploadedFile().lastIndexOf('.');
                    document.setFileExt(document.getUploadedFile().substring(index+1));
                }
                
                mav.addObject("documentFiles", documentFiles);
            }
        }
        
        if(userDetails.getRoleId() != 3) {
            for(documentFolder folder : folders) {
                List<documentFolder> folderSubfolders = documentmanager.getSubFolders(programId, userDetails, folder.getId());
                
                if(folderSubfolders != null && folderSubfolders.size() > 0) {
                    
                    for(documentFolder subfolders : folderSubfolders) {
                        List<documentFolder> subfolderSubfolders = documentmanager.getSubFolders(programId, userDetails, subfolders.getId());
                
                        if(subfolderSubfolders != null && subfolderSubfolders.size() > 0) {
                            subfolders.setSubfolders(subfolderSubfolders);
                        }
                    }
                    
                    folder.setSubfolders(folderSubfolders);
                    
                }
            }
            mav.addObject("documentfolder", folders);
        }
        else if(documentId > 0 && documentDetails.getSystemUserId() == userDetails.getId()) {
            for(documentFolder folder : folders) {
                List<documentFolder> folderSubfolders = documentmanager.getSubFolders(programId, userDetails, folder.getId());
                
                if(folderSubfolders != null && folderSubfolders.size() > 0) {
                    
                    for(documentFolder subfolders : folderSubfolders) {
                        List<documentFolder> subfolderSubfolders = documentmanager.getSubFolders(programId, userDetails, subfolders.getId());
                
                        if(subfolderSubfolders != null && subfolderSubfolders.size() > 0) {
                            subfolders.setSubfolders(subfolderSubfolders);
                        }
                    }
                    
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
            @RequestParam(value = "postDocuments", required = false) List<MultipartFile> postDocuments, 
            RedirectAttributes redirectAttr,
            HttpSession session, 
            @RequestParam(value = "alertUsers", required = false, defaultValue = "0") Integer alertUsers,
            @RequestParam(value = "fromSearch", required = false, defaultValue = "0") Integer fromSearch
    ) throws Exception {
        
        /* Get a list of completed surveys the logged in user has access to */
        User userDetails = (User) session.getAttribute("userDetails");

        documentDetails.setProgramId(programId);
        
        Integer documentId = documentDetails.getId();
        
        
        /* Check to see if the file has moved folders */
        document currDocDetails = documentmanager.getDocumentById(documentDetails.getId());
        
        String newFileNameFromMove = "";
        if(currDocDetails != null && currDocDetails.getFolderId() != documentDetails.getFolderId()) {
            /* Need to find the document and move it to the new folder */
            documentmanager.moveDocumentFile(programId, currDocDetails.getFolderId(), documentDetails.getFolderId(), documentId);
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

        ModelAndView mav;
        if(fromSearch == 1) {
            mav = new ModelAndView(new RedirectView("/documents"));
       
        }
        else {
           mav = new ModelAndView(new RedirectView("/documents/folder?i=" + encrypted[0] + "&v=" + encrypted[1]));
       }
        
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
    
    /**
     * The 'deleteFolder' POST request will change the status to false for the selected folder.
     *
     * @param documentId The id of the clicked document.
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/deleteFolder.do", method = RequestMethod.POST)
    public @ResponseBody
    String deleteFolder(HttpSession session) throws Exception {
        
        documentFolder folderDetails = documentmanager.getFolderById(selFolder);
        folderDetails.setStatus(false);
        
        documentmanager.saveFolder(folderDetails);
        
        String loadURL;
        
        if(folderDetails.getParentFolderId() > 0) {
            documentFolder parentfolderDetails = documentmanager.getFolderById(folderDetails.getParentFolderId());
            
            encryptObject encrypt = new encryptObject();
            Map<String, String> map;

            map = new HashMap<String, String>();
            map.put("id", Integer.toString(parentfolderDetails.getId()));
            map.put("topSecret", topSecret);

            String[] encrypted = encrypt.encryptObject(map);
            
            loadURL = "/documents/folder?i=" + encrypted[0] + "&v=" + encrypted[1];
       
        }
        else {
            loadURL = "/documents";
       }
        
        return loadURL;
        
    }
    
    /**
     * The '/document/getDocumentFiles.do' GET request will return the uploaded files for the selected document. 
     * form.
     *
     * @param session
     * @param subfolder
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/getDocumentFiles.do", method = RequestMethod.GET)
    public @ResponseBody
    ModelAndView getDocumentFiles(HttpSession session, @RequestParam(value = "documentId", required = true) Integer documentId) throws Exception {

        ModelAndView mav = new ModelAndView();
        mav.setViewName("/document/multiDocumentFiles");
        
        /* Get uploaded files */
        if(documentId != null && documentId > 0) {
            List<documentFile> documentFiles = documentmanager.getDocumentFiles(documentId);
            
            document documentDetails = documentmanager.getDocumentById(documentId);
            
            documentFolder folderDetails = documentmanager.getFolderById(documentDetails.getFolderId());
        
            String downloadLink = "";
            Integer folderCount = 1;

            /* Get a list of folders  */
            Integer parentFolderId = 0;
            Integer getSubFoldersFor = 0;
            Integer getSubSubFoldersFor = 0;
            if (folderDetails.getParentFolderId() > 0) {
                folderCount+=1;

                parentFolderId = folderDetails.getParentFolderId();

                documentFolder parentFolderDetails = documentmanager.getFolderById(parentFolderId);

                if(parentFolderDetails.getParentFolderId() > 0) {
                    folderCount+=1;

                    documentFolder superParentFolderDetails = documentmanager.getFolderById(parentFolderDetails.getParentFolderId());

                    downloadLink = superParentFolderDetails.getFolderName()+"/";
                }
                else {
                    getSubFoldersFor = folderDetails.getParentFolderId();
                    getSubSubFoldersFor = documentDetails.getFolderId();
                }

                downloadLink += parentFolderDetails.getFolderName()+"/"+folderDetails.getFolderName();


            } else {
                getSubFoldersFor = folderDetails.getId();
                parentFolderId = folderDetails.getId();
                downloadLink = folderDetails.getFolderName();
            }
            
            if(documentFiles != null && documentFiles.size() > 0) {
                for(documentFile doc : documentFiles) {
                    if(doc.getUploadedFile() != null && !"".equals(doc.getUploadedFile())) {
                        
                        doc.setDocumentTitle(documentDetails.getTitle());
                        
                        String encodedFileName = URLEncoder.encode(doc.getUploadedFile(),"UTF-8");
                        doc.setUploadedFile(encodedFileName);

                        doc.setDownloadLink(URLEncoder.encode(downloadLink,"UTF-8"));
                    }
                } 
                
                mav.addObject("documentFiles", documentFiles);
            }
        }
        
        return mav;
    }
    
    /**
     * The 'deleteDocumentFile' POST request will remove the clicked uploaded
     * file for the selected document.
     *
     * @param fileId The id of the clicked document.
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/deleteDocumentFile.do", method = RequestMethod.POST)
    public @ResponseBody
    Integer deleteDocumentFile(@RequestParam(value = "fileId", required = true) Integer fileId) throws Exception {

        documentmanager.deleteDocumentFile(fileId, programName);

        return 1;
    }
    
    /**
     * The 'getAvailableFoldersForTree.di' POST request will return a list of available folders for the selected
     * program and logged in user.
     *
     * @param fileId The id of the clicked document.
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/getAvailableFoldersForTree.do", method = RequestMethod.POST)
    public @ResponseBody
    JSONObject getAvailableFoldersForTree(HttpSession session, @RequestParam(value = "folderId", required = true) String folderId) throws Exception {
        
        User userDetails = (User) session.getAttribute("userDetails");
        
        JSONObject json = new JSONObject();
        JSONArray folders = new JSONArray();
        JSONObject folder;

        if(Integer.parseInt(folderId) > 0) {
           
            List<documentFolder> subfolderList = documentmanager.getSubFolders(programId, userDetails, Integer.parseInt(folderId));
            
            if (subfolderList != null && subfolderList.size() > 0) {
                
                for(documentFolder fldr : subfolderList) {
                    
                    folder = new JSONObject();
                    
                    String folderName = fldr.getFolderName();
                    
                    if(fldr.getReadOnly() == true) {
                        folderName = folderName + " (Read Only)";
                    }
                    
                    List<documentFolder> subsubfolderList = documentmanager.getSubFolders(programId, userDetails, fldr.getId());

                    if (subsubfolderList != null && subsubfolderList.size() > 0) {
                        folder.put("type", "folder");
                        folder.put("name", folderName);
                    }
                    else {
                        folder.put("type", "item");
                        folder.put("name", "<i class=\"ace-icon fa fa-folder\"></i> " + folderName);
                    }
                    folder.put("id", fldr.getId());
                    if(userDetails.getRoleId() == 2) {
                        folder.put("readOnly", false);
                    }
                    else {
                       folder.put("readOnly", fldr.getReadOnly()); 
                    }

                    folders.add(folder);
                    
                }
            }
            
        }
        else {
            List<documentFolder> folderList = documentmanager.getFolders(programId, userDetails);

            if(folderList != null && folderList.size() > 0) {

                for(documentFolder fldr : folderList) {

                    folder = new JSONObject();

                    List<documentFolder> subfolderList = documentmanager.getSubFolders(programId, userDetails, fldr.getId());

                    String folderName = fldr.getFolderName();
                    
                    if(fldr.getReadOnly() == true) {
                        folderName = folderName + " (Read Only)";
                    }
                    
                    if (subfolderList != null && subfolderList.size() > 0) {
                        folder.put("type", "folder");
                        folder.put("name", folderName);
                    }
                    else {
                        folder.put("type", "item");
                        folder.put("name", "<i class=\"ace-icon fa fa-folder green\"></i> " + folderName);
                    
                    }
                    folder.put("id", fldr.getId());
                    
                    if(userDetails.getRoleId() == 2) {
                        folder.put("readOnly", false);
                    }
                    else {
                       folder.put("readOnly", fldr.getReadOnly()); 
                    }
                    folders.add(folder);
                }
            }
        }
        
         json.put("data", folders);
        
        return json;
        
    }
    
    /**
     * The 'searchDocuments' GET request will return the view containing the table for the list of 
     * documents based on the search parameters.
     * 
     * @param request
     * @param response
     * @param session
     * @param searchString  The string containing the list of search parameters.
     * @return
     * @throws Exception 
     */
    @RequestMapping(value = "searchDocuments", method = RequestMethod.GET)
    @ResponseBody 
    public ModelAndView searchDocuments(HttpSession session, 
            @RequestParam(value = "searchString", required = false) String searchString,
            @RequestParam(value = "adminOnly", required = true) boolean adminOnly,
            @RequestParam(value = "startSearchDate", required = true) String startSearchDate,
            @RequestParam(value = "endSearchDate", required = true) String endSearchDate) throws Exception {
        
        ModelAndView mav = new ModelAndView();
        mav.setViewName("/document/documentSearchResults");
        
        session.setAttribute("searchString", searchString);
        
        if(adminOnly == false) {
            session.setAttribute("adminOnly", 0);
        }
        else {
            session.setAttribute("adminOnly", 1);
        }
        session.setAttribute("startSearchDate", startSearchDate);
        session.setAttribute("endSearchDate", endSearchDate);
        
        /* Get a list of completed surveys the logged in user has access to */
        User userDetails = (User) session.getAttribute("userDetails");
        
        String dateFrom = "";
        String dateTo = "";
        
        SimpleDateFormat df1 = new SimpleDateFormat("MM/dd/yyyy");
        SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd");
        
        if(!"".equals(startSearchDate)) {
            Date fromDate = df1.parse(startSearchDate);
            dateFrom = df.format(fromDate);
        }
        if(!"".equals(endSearchDate)) {
            Date toDate = df1.parse(endSearchDate);
            dateTo = df.format(toDate);
        }
        
        
        /* Get the documents */
        List<document> documents = documentmanager.searchDocuments(programId, userDetails, searchString, adminOnly, dateFrom, dateTo);
        
        if(documents != null && documents.size() > 0) {
            for(document doc : documents) {
            
                documentFolder folderDetails = documentmanager.getFolderById(doc.getFolderId());

                String downloadLink = "";
                Integer folderCount = 1;

                /* Get a list of folders  */
                Integer parentFolderId = 0;
                Integer getSubFoldersFor = 0;
                Integer getSubSubFoldersFor = 0;
                
                if (folderDetails.getParentFolderId() > 0) {
                    folderCount+=1;

                    parentFolderId = folderDetails.getParentFolderId();

                    documentFolder parentFolderDetails = documentmanager.getFolderById(parentFolderId);

                    if(parentFolderDetails.getParentFolderId() > 0) {
                        folderCount+=1;

                        documentFolder superParentFolderDetails = documentmanager.getFolderById(parentFolderDetails.getParentFolderId());

                        downloadLink = superParentFolderDetails.getFolderName()+"/";
                    }
                    else {
                        getSubFoldersFor = folderDetails.getParentFolderId();
                        getSubSubFoldersFor = doc.getFolderId();
                    }

                    downloadLink += parentFolderDetails.getFolderName()+"/"+folderDetails.getFolderName();


                } else {
                    getSubFoldersFor = folderDetails.getId();
                    parentFolderId = folderDetails.getId();
                    downloadLink = folderDetails.getFolderName();
                }
                
                doc.setFolderLocation(downloadLink);
                
                if(doc.getTotalFiles() == 1 && (doc.getFoundFile() != null && !"".equals(doc.getFoundFile()))) {
                    int index = doc.getFoundFile().lastIndexOf('.');
                    doc.setFileExt(doc.getFoundFile().substring(index+1));
                    
                    String encodedFileName = URLEncoder.encode(doc.getFoundFile(),"UTF-8");
                    doc.setUploadedFile(encodedFileName);
                    
                    doc.setDownloadLink(URLEncoder.encode(downloadLink,"UTF-8"));
                }
                User createdBy = usermanager.getUserById(doc.getCreatedById());
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
         mav.addObject("folders", folders);
         mav.addObject("searchString", searchString);
        
        return mav;
    }        


}
