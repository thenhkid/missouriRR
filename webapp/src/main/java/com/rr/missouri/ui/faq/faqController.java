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
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
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
    
    @RequestMapping(value = "/getCategoryForm.do", method = RequestMethod.POST)
    public @ResponseBody
    Integer displayNewCatForm(@RequestParam(value = "entityId", required = false) 
            Integer entityId, @RequestParam(value = "codeId", required = false) Integer codeId) 
            throws Exception {

        //we get add Category Form
        return (Integer) 1;
    }
    
    
    @RequestMapping(value = "/addCategory.do", method = RequestMethod.POST)
    public @ResponseBody
    Integer AddCategory(@RequestParam(value = "entityId", required = false) 
            Integer entityId, @RequestParam(value = "codeId", required = false) Integer codeId) 
            throws Exception {

        //we check to see if cat is in use, we return form
        /**
         * 
        ModelAndView mav = new ModelAndView();
        mav.setViewName("/faq/categoryModal");
        return mav;
         */
        // if not, we add category and we return 1
        return (Integer) 1;
    }
    
    @RequestMapping(value = "/editCategory.do", method = RequestMethod.POST)
    public @ResponseBody
    Integer editCategory(@RequestParam(value = "categoryId", required = false)  Integer categoryId)
            throws Exception {

        //we check to see if cat is in use, we return form
        /**
         * 
        ModelAndView mav = new ModelAndView();
        mav.setViewName("/faq/categoryModal");
        return mav;
         */
        // if not, we add category and we return 1
        return (Integer) 2;
    }
    
    @RequestMapping(value = "/deleteCategory.do", method = RequestMethod.POST)
    public @ResponseBody
    Integer deleteCategory(@RequestParam(value = "categoryId", required = false)  Integer categoryId)
            throws Exception {

        //we check to see if cat is in use, we return form
        /**
         * 
        ModelAndView mav = new ModelAndView();
        mav.setViewName("/faq/categoryModal");
        return mav;
         */
        // if not, we add category and we return 1
        return (Integer) 3;
    }
    
    @RequestMapping(value = "/getQuestionForm.do", method = RequestMethod.POST)
    public @ResponseBody
    Integer newQuestionForm(
            @RequestParam(value = "questionId", required = false) Integer questionId) 
            throws Exception {

        //we check to see if cat is in use, we return form
        /**
         * 
        ModelAndView mav = new ModelAndView();
        mav.setViewName("/faq/questionModal");
        return mav;
         */
        // if not, we add category and we return 1
        return (Integer) 1;
    }
    
    @RequestMapping(value = "/addQuestion.do", method = RequestMethod.POST)
    public @ResponseBody  
        Integer addQuestion(
            @RequestParam(value = "questionId", required = false) Integer questionId) 
            throws Exception {

        //we check to see if cat is in use, we return form
        /**
         * 
        ModelAndView mav = new ModelAndView();
        mav.setViewName("/faq/questionModal");
        return mav;
         */
        // if not, we add category and we return 1
        return (Integer) 1;
    }
    
    
    @RequestMapping(value = "/editQuestion.do", method = RequestMethod.POST)
    public @ResponseBody
    Integer editQuestion(
            @RequestParam(value = "questionId", required = false) Integer questionId) 
            throws Exception {

        //we check to see if cat is in use, we return form
        /**
         * 
        ModelAndView mav = new ModelAndView();
        mav.setViewName("/faq/questionModal");
        return mav;
         */
        // if not, we add category and we return 1
        return (Integer) 2;
    }
    
    @RequestMapping(value = "/deleteQuestion.do", method = RequestMethod.POST)
    public @ResponseBody
    Integer deleteQuestion(
            @RequestParam(value = "questionId", required = false) Integer questionId) 
            throws Exception {

        //we check to see if cat is in use, we return form
        /**
         * 
        ModelAndView mav = new ModelAndView();
        mav.setViewName("/faq/questionModal");
        return mav;
         */
        // if not, we add category and we return 1
        return (Integer) 3;
    }
    
    @RequestMapping(value = "/getDocumentForm.do", method = RequestMethod.POST)
    public @ResponseBody
    Integer newDocumentForm(
            @RequestParam(value = "documentId", required = false) Integer documentId) 
            throws Exception {

        //we check to see if cat is in use, we return form
        /**
         * 
        ModelAndView mav = new ModelAndView();
        mav.setViewName("/faq/questionModal");
        return mav;
         */
        // if not, we add category and we return 1
        return (Integer) 1;
    }
    
    @RequestMapping(value = "/addDocument.do", method = RequestMethod.POST)
    public @ResponseBody  
        Integer addDocument(
            @RequestParam(value = "documentId", required = false) Integer documentId) 
            throws Exception {

        //we check to see if cat is in use, we return form
        /**
         * 
        ModelAndView mav = new ModelAndView();
        mav.setViewName("/faq/questionModal");
        return mav;
         */
        // if not, we add category and we return 1
        return (Integer) 1;
    }
    
    
    @RequestMapping(value = "/editDocument.do", method = RequestMethod.POST)
    public @ResponseBody
    Integer editDocument(
            @RequestParam(value = "documentId", required = false) Integer documentId) 
            throws Exception {

        //we check to see if cat is in use, we return form
        /**
         * 
        ModelAndView mav = new ModelAndView();
        mav.setViewName("/faq/questionModal");
        return mav;
         */
        // if not, we add category and we return 1
        return (Integer) 2;
    }
    
    @RequestMapping(value = "/deleteDocument.do", method = RequestMethod.POST)
    public @ResponseBody
    Integer deleteDocument(
            @RequestParam(value = "documentId", required = false) Integer documentId) 
            throws Exception {

        //we check to see if cat is in use, we return form
        /**
         * 
        ModelAndView mav = new ModelAndView();
        mav.setViewName("/faq/questionModal");
        return mav;
         */
        // if not, we add category and we return 1
        return (Integer) 3;
    }
    
    
}
