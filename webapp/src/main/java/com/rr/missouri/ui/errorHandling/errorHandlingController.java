/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.rr.missouri.ui.errorHandling;

import com.registryKit.errorHandling.errorHandlingManager;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.servlet.ModelAndView;


@ControllerAdvice
public class errorHandlingController{
    
    @Autowired
    private errorHandlingManager errormanager;
    
    @ExceptionHandler(Exception.class)
    public ModelAndView exception(HttpSession session, Exception e, 
    		HttpServletRequest request, Authentication authentication) throws Exception {
         
         ModelAndView mav = new ModelAndView();
         mav.setViewName("/exception");
         try {
             errormanager.sendMessageToAdmin(session, e, request, authentication); 
         } catch (Exception ex) {
                ex.printStackTrace();
        	System.err.println(ex.toString() + " error at exception");
         }
         
         
         return mav;
    }
}
