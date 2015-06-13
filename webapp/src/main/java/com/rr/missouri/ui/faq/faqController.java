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
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.ModelAttribute;
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
    ModelAndView displayCatForm(
            @RequestParam(value = "toDo", required = true) String toDo, 
            @RequestParam(value = "categoryId", required = false) Integer categoryId) 
            throws Exception {
        
        ModelAndView mav = new ModelAndView();
        //we return form
        faqCategories category = new faqCategories();
        Integer maxDisPos = faqManager.getFAQCategories(programId).size();
        
        if (toDo.equalsIgnoreCase("Edit")) {
            category = faqManager.getCategoryById(categoryId);
        } else {
            category.setDisplayPos(maxDisPos + 1);
            category.setProgramId(programId);
            maxDisPos = maxDisPos + 1;
        }
        
        mav.addObject("category", category);
        
        //we add max display order
        mav.addObject("maxPos", maxDisPos);
        mav.setViewName("/faq/categoryModal");
        return mav;
    }
    
    
    @RequestMapping(value = "/addCategory.do", method = RequestMethod.POST)
    public @ResponseBody
    ModelAndView AddCategory(@ModelAttribute(value = "category") faqCategories category, BindingResult errors) 
            throws Exception {
        
        Integer maxDisPos = faqManager.getFAQCategories(programId).size();
        
        ModelAndView mav = new ModelAndView();
        mav.setViewName("/faq/categoryModal");
        mav.addObject("category", category);
        mav.addObject("maxPos", maxDisPos);
        
        faqCategories categoryToReplace = faqManager.getCategoryByDspPos(programId, category.getDisplayPos());
                    
        //see if any category is using the new display position
        if (categoryToReplace != null) {
                if(category.getId() == 0) {
                    categoryToReplace.setDisplayPos(maxDisPos);
                } else {
                    //get old position
                    categoryToReplace.setDisplayPos(faqManager.getCategoryById(category.getId()).getDisplayPos());
                }
                faqManager.saveCategory(categoryToReplace);
        }
        //insert or update here
        faqManager.saveCategory(category);
        //return correct message
        mav.setViewName("/faq/result");
        mav.addObject("edited", 1);
        return mav;
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
