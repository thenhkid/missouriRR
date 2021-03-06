/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.rr.missouri.ui.controller;

import com.registryKit.announcements.announcement;
import com.registryKit.announcements.announcementDocuments;
import com.registryKit.announcements.announcementManager;
import com.registryKit.faq.faqManager;
import com.registryKit.faq.faqQuestions;
import com.registryKit.program.program;
import com.registryKit.program.programManager;
import com.registryKit.user.User;
import com.registryKit.messenger.emailManager;
import com.registryKit.messenger.emailMessage;
import com.registryKit.user.userManager;
import java.math.BigInteger;
import java.net.URLDecoder;
import java.net.URLEncoder;
import java.util.List;
import java.util.List;
import java.util.Random;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
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
public class mainController {
    
    @Value("${programId}")
    private Integer programId;
    
    @Autowired
    private userManager usermanager;
    
    @Autowired
    private emailManager emailManager;
    
    @Autowired
    private programManager programmanager;
    
    @Autowired
    private announcementManager announcementmanager;
    
    @Autowired
    faqManager faqManager;
    
    /**
     * The '/login' request will serve up the login page.
     *
     * @param request
     * @param response
     * @return	the login page view
     * @throws Exception
     */
    @RequestMapping(value = "/login", method = RequestMethod.GET)
    public ModelAndView login() throws Exception {
        
        program programDetails = programmanager.getProgramById(programId);
        
        ModelAndView mav = new ModelAndView();
        mav.setViewName("/login");
        mav.addObject("programName", programDetails.getProgramName());

        return mav;

    }

    /**
     * The '/loginfailed' request will serve up the login page displaying the login failed error message
     *
     * @param request
     * @param response
     * @return	the error object and the login page view
     * @throws Exception
     */
    @RequestMapping(value = "/loginfailed", method = RequestMethod.GET)
    public ModelAndView loginerror(HttpServletRequest request, HttpServletResponse response) throws Exception {
        
        program programDetails = programmanager.getProgramById(programId);
        
        ModelAndView mav = new ModelAndView();
        mav.setViewName("/login");
        mav.addObject("programName", programDetails.getProgramName());
        mav.addObject("error", "true");
        return mav;

    }

    /**
     * The '/logout' request will handle a user logging out of the system. The request will handle front-end users or administrators logging out.
     *
     * @param request
     * @param response
     * @return	the login page view
     * @throws Exception
     */
    @RequestMapping(value = "/logout", method = RequestMethod.GET)
    public ModelAndView logout(HttpServletRequest request, HttpServletResponse response) throws Exception {
        
        program programDetails = programmanager.getProgramById(programId);
       
        ModelAndView mav = new ModelAndView();
        mav.setViewName("/login");
        mav.addObject("programName", programDetails.getProgramName());

        return mav;
    }

    /**
     * The '/' request will be the default request of the translator. The request will serve up the home page of the translator.
     *
     * @param request
     * @param response
     * @return	the home page view
     * @throws Exception
     */
    @RequestMapping(value = "/", method = {RequestMethod.GET, RequestMethod.HEAD})
    public ModelAndView welcome(HttpServletRequest request, HttpServletResponse response, RedirectAttributes redirectAttr, HttpSession session) throws Exception {
        
       ModelAndView mav = new ModelAndView(new RedirectView("/login"));
       return mav; 
       
    }
    
    /**
     * The '/home' request will serve up the home page.
     *
     * @param request
     * @param response
     * @return	the login page view
     * @throws Exception
     */
    @RequestMapping(value = "/home", method = RequestMethod.GET)
    public ModelAndView home(HttpSession session) throws Exception {
        
        ModelAndView mav = new ModelAndView();
        mav.setViewName("/home");
        
        User userDetails = (User) session.getAttribute("userDetails");
        
        /* Check for any home page announcements */
        List<announcement> announcements = announcementmanager.getHomePageAnnouncements(programId, userDetails);
        
        if(announcements != null && announcements.size() > 0) {
            for(announcement anncment:announcements) {
                if(anncment.getTotalDocuments() > 0) {
                    List<announcementDocuments> documents = announcementmanager.getAnnouncementDocuments(anncment.getId());
                    
                    if(documents != null && documents.size() > 0) {
                        for(announcementDocuments doc : documents) {
                            if(doc.getUploadedFile() != null && !"".equals(doc.getUploadedFile())) {
                                int index = doc.getUploadedFile().lastIndexOf('.');
                                doc.setFileExt(doc.getUploadedFile().substring(index+1));

                                if(doc.getUploadedFile().length() > 60) {
                                    String shortenedTitle = doc.getUploadedFile().substring(0,30) + "..." + doc.getUploadedFile().substring(doc.getUploadedFile().length()-10, doc.getUploadedFile().length());
                                    doc.setShortenedTitle(shortenedTitle);
                                }
                                doc.setEncodedTitle(URLEncoder.encode(doc.getUploadedFile(),"UTF-8"));
                            }
                        }
                        anncment.setDocuments(documents);
                    }
                }
            }
        }
        
        mav.addObject("announcements", announcements);
       
        return mav;

    }
    
    /**
     * The '/forgotPassword.do' POST request will be used to find the account information for the user and send an email.
     *
     *
     */
    @RequestMapping(value = "/forgotPassword.do", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
    public @ResponseBody
    Integer findPassword(@RequestParam String identifier) throws Exception {

        Integer userId = usermanager.getUserByIdentifier(identifier);

        if (userId == null) {
            return 0;
        } else {

            return userId;
        }

    }

    /**
     * The '/sendPassword.do' POST request will be used to send the reset email to the user.
     *
     * @param userId The id of the return user.
     */
    @RequestMapping(value = "/sendPassword.do", method = RequestMethod.POST)
    public void sendPassword(@RequestParam Integer userId, HttpServletRequest request) throws Exception {
        
        String randomCode = generateRandomCode();

        User userDetails = usermanager.getUserById(userId);
        userDetails.setresetCode(randomCode);

        usermanager.updateUser(userDetails);
        
        program programDetails = programmanager.getProgramById(programId);

        /* Sent Reset Email */
        emailMessage messageDetails = new emailMessage();

        messageDetails.settoEmailAddress(userDetails.getEmail());
        messageDetails.setmessageSubject(programDetails.getProgramName() + " Reset Password");
        
        String resetURL = request.getRequestURL().toString().replace("sendPassword.do", "resetPassword?b=");
        
        StringBuilder sb = new StringBuilder();

        sb.append("Dear ").append(userDetails.getFirstName()).append(",<br />");
        sb.append("You have recently asked to reset your ").append(programDetails.getProgramName()).append(" password.<br /><br />");
        sb.append("<a href='").append(resetURL).append(randomCode).append("'>Click here to reset your password.</a>");

        messageDetails.setmessageBody(sb.toString());
        messageDetails.setfromEmailAddress(programDetails.getEmailAddress());

        emailManager.sendEmail(messageDetails);

    }

    /**
     * The '/resetPassword' GET request will be used to display the reset password form
     *
     *
     * @return	The forget password form page
     *
     *
     */
    @RequestMapping(value = "/resetPassword", method = RequestMethod.GET)
    public ModelAndView resetPassword(@RequestParam(value = "b", required = false) String resetCode, HttpSession session) throws Exception {

        ModelAndView mav = new ModelAndView();
        mav.setViewName("/resetPassword");
        mav.addObject("resetCode", resetCode);

        return mav;
    }

    /**
     * The '/resetPassword' POST request will be used to display update the users password
     *
     * @param resetCode The code that was set to reset a user for.
     * @param newPassword The password to update the user to
     *
     */
    @RequestMapping(value = "/resetPassword", method = RequestMethod.POST)
    public ModelAndView resetPassword(@RequestParam String resetCode, @RequestParam String newPassword, HttpSession session, RedirectAttributes redirectAttr) throws Exception {

        User userDetails = usermanager.getUserByResetCode(resetCode);

        if (userDetails == null) {
            redirectAttr.addFlashAttribute("msg", "notfound");

            ModelAndView mav = new ModelAndView(new RedirectView("/login"));
            return mav;
        } else {
            userDetails.setresetCode(null);
            userDetails.setPassword(newPassword);
            userDetails = usermanager.encryptPW(userDetails);

            usermanager.updateUser(userDetails);

            redirectAttr.addFlashAttribute("msg", "updated");

            ModelAndView mav = new ModelAndView(new RedirectView("/login"));
            return mav;
        }

    }

    /**
     * The 'generateRandomCode' function will be used to generate a random access code to reset a users password. The function will call itself until it gets a unique code.
     *
     * @return This function returns a randomcode as a string
     */
    public String generateRandomCode() {

    	Random random = new Random();
        String randomCode = new BigInteger(130, random).toString(32);
       
        /* Check to make sure there is not reset code already generated */
        User usedCode = usermanager.getUserByResetCode(randomCode);

        if (usedCode == null) {
            return randomCode;
        } else {

            return generateRandomCode();

        }

    }
    
    /**
     * The '/search/documents/{pathVariable}' request will handle viewing a file clicked from the email.
     *
     * @param request
     * @param response
     * @return	the login page view
     * @throws Exception
     */
    @RequestMapping(value = "/search/documents/{pathVariable}", method = RequestMethod.GET)
    public ModelAndView viewDocumentFromEmail(HttpSession session, HttpServletRequest request, @PathVariable String pathVariable) throws Exception {
        
        String url = request.getRequestURL().toString();
        int slashIndex = url.lastIndexOf('/');
        int dotIndex = url.lastIndexOf('.');
        
        if(dotIndex > 0) {
            String filename = url.substring(slashIndex + 1);
            session.setAttribute("searchmoduleName","documents");
            session.setAttribute("searchString", URLDecoder.decode(filename,"UTF-8"));
        }
        
        //Redirect to the log in page.
        ModelAndView mav = new ModelAndView(new RedirectView("/login"));
        return mav;
    }
    
    /**
     * The '/search/forums/{pathVariable}' request will handle viewing a forum topic clicked from the email.
     *
     * @param request
     * @param response
     * @return	the login page view
     * @throws Exception
     */
    @RequestMapping(value = "/search/forums/{pathVariable}", method = RequestMethod.GET)
    public ModelAndView viewForumTopicFromEmail(HttpSession session, HttpServletRequest request, @PathVariable String pathVariable) throws Exception {
        
        if(!"".equals(pathVariable)) {
            session.setAttribute("searchmoduleName","forum/"+pathVariable);
        }
        
        //Redirect to the log in page.
        ModelAndView mav = new ModelAndView(new RedirectView("/login"));
        return mav;
        
    }
    
    /**
     * The '/search/announcements' request will handle viewing a announcements clicked from the email.
     *
     * @param request
     * @param response
     * @return	the login page view
     * @throws Exception
     */
    @RequestMapping(value = "/search/announcements", method = RequestMethod.GET)
    public ModelAndView viewAnnouncementFromEmail(HttpSession session, HttpServletRequest request) throws Exception {
        
        session.setAttribute("searchmoduleName","announcements");
        
        //Redirect to the log in page.
        ModelAndView mav = new ModelAndView(new RedirectView("/login"));
        return mav;
        
    }
}
