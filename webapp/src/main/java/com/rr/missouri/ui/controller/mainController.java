/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.rr.missouri.ui.controller;

import com.registryKit.program.program;
import com.registryKit.program.programManager;
import com.registryKit.user.User;
import com.registryKit.user.emailMessageManager;
import com.registryKit.user.mailMessage;
import com.registryKit.user.userManager;
import java.math.BigInteger;
import java.util.Random;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Controller;
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
    private emailMessageManager emailMessageManager;
    
    @Autowired
    private programManager programmanager;
    
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
        mailMessage messageDetails = new mailMessage();

        messageDetails.settoEmailAddress(userDetails.getEmail());
        messageDetails.setmessageSubject(programDetails.getProgramName() + " Reset Password");
        
        String resetURL = request.getRequestURL().toString().replace("sendPassword.do", "resetPassword?b=");
        
        StringBuilder sb = new StringBuilder();

        sb.append("Dear " + userDetails.getFirstName() + ",<br />");
        sb.append("You have recently asked to reset your " + programDetails.getProgramName() + " password.<br /><br />");
        sb.append("<a href='" + resetURL + randomCode + "'>Click here to reset your password.</a>");

        messageDetails.setmessageBody(sb.toString());
        messageDetails.setfromEmailAddress(programDetails.getEmailAddress());

        emailMessageManager.sendEmail(messageDetails);

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
    
}
