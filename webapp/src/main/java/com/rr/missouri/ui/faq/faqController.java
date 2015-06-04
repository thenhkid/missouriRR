/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.rr.missouri.ui.faq;

import com.registryKit.faq.faqCategories;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import com.registryKit.faq.faqManager;
import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.ModelAndView;

/**
 *
 * @author chadmccue
 */
@Controller
@RequestMapping("/faq")
public class faqController {
    
   @Autowired
   faqManager faqManager;
    
   @Value("${programId}")
   private Integer programId;
   
   @Value("${topSecret}")
   private String topSecret;
   
   @RequestMapping(value = "", method = RequestMethod.GET)
    public ModelAndView faq() throws Exception {
        
        ModelAndView mav = new ModelAndView();
        mav.setViewName("/faq");
        
        List <faqCategories> categoryList = faqManager.getFAQForProgram(programId);
        
        mav.addObject("categoryList", categoryList);
        return mav;
    }
    
}
