/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.rr.missouri.ui.importexport;

import com.registryKit.importTool.importManager;
import com.registryKit.importTool.programImportTypeFields;
import com.registryKit.importTool.programImportTypes;
import com.registryKit.importTool.programImports;
import com.registryKit.program.program;
import com.registryKit.program.programManager;
import com.registryKit.user.User;
import com.rr.missouri.ui.reference.fileSystem;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
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
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import org.springframework.web.servlet.view.RedirectView;

/**
 *
 * @author chadmccue
 */
@Controller
@RequestMapping("/import-export")
public class importexportController {
    
    @Autowired
    private programManager programmanager;
    
    @Autowired
    private importManager importmanager;
    
     @Value("${programId}")
    private Integer programId;
    
    
    /**
     * The '' request will display the list of client.
     *
     * @param request
     * @param response
     * @return	the administrator dashboard view
     * @throws Exception
     */
    @RequestMapping(value = {"","/import"}, method = RequestMethod.GET)
    public ModelAndView importData(HttpServletRequest request, HttpServletResponse response, HttpSession session) throws Exception {
        
        program programDetails = programmanager.getProgramById(programId);

        ModelAndView mav = new ModelAndView();
        mav.setViewName("/importData");
        
        List<programImportTypes> importTypes = importmanager.getImportTypes(programId);
        mav.addObject("importTypes", importTypes);
        
        return mav;
    }
    
    /**
     * The '/fileUploadForm' GET request will be used to display the blank file upload screen (In a modal)
     *
     *
     * @return	The file upload blank form page
     *
     *
     */
    @RequestMapping(value = "/fileUploadForm", method = RequestMethod.GET)
    public @ResponseBody
    ModelAndView fileUploadForm(@RequestParam(value = "importTypeId", required = true) Integer importTypeId, HttpSession session) throws Exception {

        ModelAndView mav = new ModelAndView();
        mav.setViewName("/import-export/uploadForm");
        
        /* Get the import type details */
        programImportTypes importType = importmanager.getImportTypeById(importTypeId);

        mav.addObject("importTypeDetails", importType);

        return mav;
    }
    
    /**
     * The '/submitFileUpload' POST request will submit the new file and run the file through various validations. 
     * If a single validation fails the upload will be put in a error validation status and the file will be removed from the system. The user will receive an error message on the screen letting them know which 
     * validations have failed and be asked to upload a new file.
     *
     * The following validations will be taken place. 
     * - File is not empty 
     * - File contains the appropriate data elements
     */
    @RequestMapping(value = "/submitFileUpload", method = RequestMethod.POST)
    public @ResponseBody
    ModelAndView submitFileUpload(RedirectAttributes redirectAttr, HttpSession session, @RequestParam(value = "importTypeId", required = true) Integer importTypeId, @RequestParam(value = "uploadedFile", required = true) MultipartFile uploadedFile) throws Exception {
        
        User userDetails = (User) session.getAttribute("userDetails");
        
        try {
            
            DateFormat dateFormat = new SimpleDateFormat("yyyyMMddHHmmssS");
            Date date = new Date();
            
            /* Get the details of the upload type */
            programImportTypes importType = importmanager.getImportTypeById(importTypeId);
            
            //adding transport method id to UT batch name
            String uploadFileName = new StringBuilder().append(importType.getName().replaceAll(" ", "-").toLowerCase()).append(dateFormat.format(date)).toString();

            /* Upload the file */
            Map<String, String> uploadResults =  null;
            
            //Set the directory to save the uploaded message type template to
            fileSystem programdir = new fileSystem();

            program programDetails = programmanager.getProgramById(importType.getProgramId());

            programdir.setDir(programDetails.getProgramName().replaceAll(" ", "-").toLowerCase(), "import files");
            
            //need to write the file first, we will write it to our process folder
            File savedFile = new File(programdir.getDir() + uploadFileName + ".csv");
            savedFile.createNewFile();
            
            MultipartFile file = uploadedFile;
            
            try {
                InputStream inputStream = file.getInputStream();
                OutputStream outputStream = new FileOutputStream(savedFile);
                
                int read = 0;
                byte[] bytes = new byte[1024];

                while ((read = inputStream.read(bytes)) != -1) {
                    outputStream.write(bytes, 0, read);
                }
                outputStream.close();
            
            }catch (IOException e) {
                System.err.println("import file upload error: " + e.getCause());
                e.printStackTrace();
                return null;
            }
        
            //check uploaded file 
            uploadResults = importmanager.chkUploadImportFile(importTypeId, savedFile); 
            
            /* Check that the uploaded file has the correct fields */
            List<programImportTypeFields> fields = importmanager.getImportTypeFields(importTypeId);
            Map<String, String> importFileResults = importmanager.checkImportFileFields(fields, savedFile);
            
            if(importFileResults.get("correctFields") == "false") {
                uploadResults.put("correctFields", "false");
            }
            
            Integer totalErrors = 0;
            
            Object emptyFileVal = uploadResults.get("emptyFile");
            if (emptyFileVal != null) {
                totalErrors+=1;
            }
            
            Object wrongSizeVal = uploadResults.get("wrongSize");
            if (wrongSizeVal != null) {
                totalErrors+=1;
            }
            
            Object wrongFileTypeVal = uploadResults.get("wrongFileType");
            if (wrongFileTypeVal != null) {
                totalErrors+=1;
            }
            
            Object wrongFieldsVal = uploadResults.get("correctFields");
            if (wrongFieldsVal != null) {
                totalErrors+=1;
            }
            
            /* Submit a new batch */
            programImports programImport = new programImports();
            programImport.setProgramId(programId);
            programImport.setProgramUploadTypeId(importTypeId);
            programImport.setSystemUserId(userDetails.getId());
            programImport.setTotalRows(Integer.parseInt(importFileResults.get("totalRows")));
            programImport.setTotalInError(totalErrors);
            programImport.setFileName(uploadFileName);
            
            Integer importId = (Integer) importmanager.submitImport(programImport);

            List<Integer> errorCodes = new ArrayList<Integer>();

            if (emptyFileVal != null) {
                errorCodes.add(1);
            }

            if (wrongSizeVal != null) {
                errorCodes.add(2);
            }

            if (wrongFileTypeVal != null) {
                errorCodes.add(3);
            }

            if (wrongFieldsVal != null) {
                errorCodes.add(4);
            }

            /* If Passed validation process the file */
            if (0 == errorCodes.size()) {
                
                importmanager.processImportedFile(userDetails.getId(), importId, fields, savedFile);

                /* Redirect to the list of uploaded batches */
                redirectAttr.addFlashAttribute("savedStatus", "uploaded");

            } else {
                redirectAttr.addFlashAttribute("savedStatus", "error");
                redirectAttr.addFlashAttribute("errorCodes", errorCodes);
            }

            
            ModelAndView mav = new ModelAndView(new RedirectView("import-export"));
            return mav;

        } catch (Exception e) {
            throw new Exception("Error occurred uploading a new import file", e);
        }

    }
}
