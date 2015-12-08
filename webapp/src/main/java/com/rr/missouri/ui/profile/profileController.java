/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.rr.missouri.ui.profile;

import com.registryKit.user.User;
import com.registryKit.user.userManager;
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

/**
 *
 * @author chadmccue
 */
@Controller
@RequestMapping("/profile")
public class profileController {

    @Autowired
    private userManager usermanager;

    @Value("${programId}")
    private Integer programId;

    @Value("${topSecret}")
    private String topSecret;

    /**
     * The 'profile' GET method will return the user profile page.
     *
     * @param session
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "", method = RequestMethod.GET)
    public ModelAndView profile(HttpSession session) throws Exception {

        ModelAndView mav = new ModelAndView();
        mav.setViewName("/profile");

        /* Get a list of completed surveys the logged in user has access to */
        User userDetails = (User) session.getAttribute("userDetails");

        mav.addObject("userDetails", userDetails);

        return mav;
    }

    /**
     * The 'saveProfileForm.do' POST will save the user profile form.
     *
     * @param session
     * @param email
     * @param firstName
     * @param lastName
     * @param newPassword
     * @param profilePhoto
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "saveProfileForm.do", method = RequestMethod.POST)
    public ModelAndView submitProfileForm(HttpSession session, @RequestParam String email,
            @RequestParam String username,
            @RequestParam String firstName,
            @RequestParam String lastName,
            @RequestParam String newPassword,
            @RequestParam(value = "profilePhoto", required = false) MultipartFile profilePhoto) throws Exception {

        ModelAndView mav = new ModelAndView();
        mav.setViewName("/profile");

        /* Get a list of completed surveys the logged in user has access to */
        User userDetails = (User) session.getAttribute("userDetails");
        
        /* Check for duplicate email address */
        User existingUser = usermanager.checkDuplicateUsername(username, programId, userDetails.getId());
        
        if (existingUser != null ) {
            mav.addObject("existingUser", "The username is already being used by another user.");
            return mav;
        }
        
        
        userDetails.setFirstName(firstName);
        userDetails.setLastName(lastName);
        userDetails.setEmail(email);
        userDetails.setUsername(username);

        if (!"".equals(newPassword)) {
            userDetails.setPassword(newPassword);
            userDetails = usermanager.encryptPW(userDetails);
        }

        if (profilePhoto != null && !"".equals(profilePhoto) && profilePhoto.getSize() > 0) {
            String profilePhotoFileName = usermanager.saveProfilePhoto(programId, profilePhoto, userDetails);
            userDetails.setProfilePhoto(profilePhotoFileName);
        }

        usermanager.updateUser(userDetails);
        
        mav.addObject("savedStatus", "updated");

        return mav;
    }

    /**
     * The 'removePhoto' POST method will remove the uploaded profile photo.
     *
     * @param session
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "removePhoto", method = RequestMethod.POST)
    public @ResponseBody
    Integer removeProfilePhoto(HttpSession session) throws Exception {

        User userDetails = (User) session.getAttribute("userDetails");
        userDetails.setProfilePhoto("");

        usermanager.updateUser(userDetails);

        return 1;
    }

}
