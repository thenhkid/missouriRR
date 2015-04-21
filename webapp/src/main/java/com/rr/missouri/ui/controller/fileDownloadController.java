package com.rr.missouri.ui.controller;

import com.registryKit.program.program;
import com.registryKit.program.programManager;
import com.rr.missouri.ui.reference.fileSystem;
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
import javax.servlet.ServletContext;
import javax.servlet.http.HttpServletRequest;

@Controller
@RequestMapping("/FileDownload")
public class fileDownloadController {

    @Autowired
    programManager programmanager;

    /**
     * Size of a byte buffer to read/write file
     */
    private static final int BUFFER_SIZE = 4096;

    @RequestMapping(value = "/downloadFile.do", method = RequestMethod.GET)
    public void downloadFile(HttpServletRequest request, Authentication authentication,
            @RequestParam String filename, @RequestParam String foldername, @RequestParam(value = "programId", required = false) Integer programId, HttpServletResponse response) throws Exception {
        String desc = "";
        
        OutputStream outputStream = null;
        InputStream in = null;
        ServletContext context = request.getServletContext();
        String errorMessage = "";

        try {
            fileSystem dir = new fileSystem();

            if (programId != null && programId > 0) {

                program programDetails = programmanager.getProgramById(programId);

                dir.setDir(programDetails.getProgramName(), foldername);
            } else {
                dir.setDirByName(foldername + "/");
            }

            String mimeType = context.getMimeType(dir.getDir() + filename);

            File f = new File(dir.getDir() + filename);

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
    }

}
