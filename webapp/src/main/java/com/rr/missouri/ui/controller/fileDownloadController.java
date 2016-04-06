package com.rr.missouri.ui.controller;

import com.registryKit.document.documentFolder;
import com.registryKit.document.documentManager;
import com.registryKit.messenger.emailManager;
import com.registryKit.messenger.emailMessage;
import com.registryKit.program.program;
import com.registryKit.program.programManager;
import com.registryKit.reference.fileSystem;
import com.rr.missouri.ui.security.encryptObject;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;

import javax.servlet.http.HttpServletResponse;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RequestMethod;
import java.io.File;
import java.util.HashMap;
import java.util.Map;
import java.util.Properties;
import javax.annotation.Resource;
import javax.servlet.ServletContext;
import javax.servlet.http.HttpServletRequest;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import org.springframework.web.servlet.view.RedirectView;

@Controller
@RequestMapping("/FileDownload")
public class fileDownloadController {
    
    @Resource(name = "myProps")
    private Properties myProps;

    @Value("${programId}")
    private Integer programId;
    
    @Value("${programName}")
    private String programName;
    
    @Value("${topSecret}")
    private String topSecret;

    @Autowired
    programManager programmanager;
    
    @Autowired
    documentManager documentmanager;
    
    @Autowired
    emailManager emailManager;

    /**
     * Size of a byte buffer to read/write file
     */
    private static final int BUFFER_SIZE = 4096;

    @RequestMapping(value = "/downloadFile.do", method = RequestMethod.GET)
    public ModelAndView downloadFile(HttpServletRequest request, Authentication authentication,
            @RequestParam String filename, @RequestParam String foldername, HttpServletResponse response, RedirectAttributes redirectAttr) throws Exception {
        String desc = "";

        OutputStream outputStream = null;
        InputStream in = null;
        ServletContext context = request.getServletContext();
        String errorMessage = "";

        try {
            fileSystem dir = new fileSystem();

            if (programId != null && programId > 0) {

                program programDetails = programmanager.getProgramById(programId);

                dir.setDir(programDetails.getProgramName().replaceAll(" ", "-").toLowerCase(), foldername);
            } else {
                dir.setDirByName(foldername + "/");
            }

            String mimeType = context.getMimeType(dir.getDir() + filename);

            File f = new File(dir.getDir() + filename);
            
            if(f.exists()) {

                if (mimeType == null) {
                    // set to binary type if MIME mapping not found
                    mimeType = "application/octet-stream";
                }
                response.setContentType(mimeType);

                in = new FileInputStream(dir.getDir() + filename);
                byte[] buffer = new byte[BUFFER_SIZE];
                int bytesRead = 0;

                response.setContentLength((int) f.length());
                response.setHeader("Content-Transfer-Encoding", "binary");
                response.setHeader("Content-Disposition", "attachment;filename=\"" + filename + "\"");

                outputStream = response.getOutputStream();
                while (0 < (bytesRead = in.read(buffer))) {
                    outputStream.write(buffer, 0, bytesRead);
                }

                in.close();
                outputStream.close();
                return null;
            }
            else {
                Integer lastSlash = foldername.lastIndexOf("/");
                String folderName = foldername.substring(lastSlash+1, foldername.length());
                
                /* Get the folder details */
                documentFolder folderDetails = documentmanager.getFolderByName(programId, folderName);
                
                /* Sent Missing Document Email */
                emailMessage messageDetails = new emailMessage();
                messageDetails.settoEmailAddress("rrnotifications@gmail.com");
                messageDetails.setmessageSubject(programName + " (" + myProps.getProperty("server.identity") + ")" + " - Missing Document");
                
                StringBuilder sb = new StringBuilder();

                sb.append("The following file was clicked but can't be found.<br /><br />");
                sb.append("file Name: " +filename+"<br /><br />");
                sb.append("Location: " + dir.getDir() + filename);
                
                messageDetails.setmessageBody(sb.toString());
                messageDetails.setfromEmailAddress("gchan@health-e-link.net");
                
                emailManager.sendEmail(messageDetails);
                
                if(folderDetails != null && request.getHeader("referer").contains("folder")) {
                    encryptObject encrypt = new encryptObject();
                    Map<String, String> map;
                    map = new HashMap<String, String>();
                    map.put("id", Integer.toString(folderDetails.getId()));
                    map.put("topSecret", topSecret);

                    String[] encrypted = encrypt.encryptObject(map);
                    
                    redirectAttr.addFlashAttribute("error", "missing");
                    ModelAndView mav = new ModelAndView(new RedirectView("/documents/folder?i="+encrypted[0]+"&v="+encrypted[1]));
                    return mav;
                }
                else {
                    redirectAttr.addFlashAttribute("error", "missing");
                    ModelAndView mav = new ModelAndView(new RedirectView(request.getHeader("referer")));
                    return mav;
                }
            }

        } catch (FileNotFoundException e) {
            errorMessage = e.getMessage();
            e.printStackTrace();

        } catch (IOException e) {
            errorMessage = e.getMessage();
            e.printStackTrace();
        } finally {
            if (null != in) {
                try {
                    in.close();
                } catch (IOException e) {
                    errorMessage = e.getMessage();
                    e.printStackTrace();
                }
            }
        }

        /**
         * throw error message here because want to make sure file stream is closed *
         */
        if (!errorMessage.equalsIgnoreCase("")) {
            throw new Exception(errorMessage);
        }
        
        return null;
    }

}
