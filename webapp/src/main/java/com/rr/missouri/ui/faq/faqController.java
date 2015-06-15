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
import com.registryKit.faq.faqQuestions;
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
    
    
    @RequestMapping(value = "/saveCategory.do", method = RequestMethod.POST)
    public @ResponseBody
    ModelAndView saveCategory(@ModelAttribute(value = "category") faqCategories category, BindingResult errors) 
            throws Exception {
        
        Integer maxDisPos = faqManager.getFAQCategories(programId).size();
        
        ModelAndView mav = new ModelAndView();
        
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
        if (category.getId() == 0) {
            mav.addObject("edited", 1);
        } else {
            mav.addObject("edited", 2);
        }
        return mav;
    }
    
    /**
     * This takes in a category and deletes its questions and documents
     * @param category
     * @param errors
     * @return
     * @throws Exception 
     */
    @RequestMapping(value = "/deleteCategory.do", method = RequestMethod.POST)
    public @ResponseBody
    ModelAndView deleteCategory(@ModelAttribute(value = "category") faqCategories category, BindingResult errors)
            throws Exception {
        System.out.println(category.getId());
        faqManager.deleteCategory(category);
        //reorder all displayPos
        faqManager.reOrderCategoryByDspPos(programId);
   
        ModelAndView mav = new ModelAndView();
        mav.setViewName("/faq/result");
        mav.addObject("edited", 3);
        return mav;
    }
    
    @RequestMapping(value = "/getQuestionForm.do", method = RequestMethod.POST)
    public @ResponseBody
    ModelAndView displayQuestionForm(
            @RequestParam(value = "toDo", required = true) String toDo, 
            @RequestParam(value = "questionId", required = true) Integer questionId
            ) 
            throws Exception {
        
        //need category list
        List <faqCategories> categories = faqManager.getFAQCategories(programId);
        ModelAndView mav = new ModelAndView();
        
        faqQuestions question = new faqQuestions();
        Integer maxDisPos = 0;
        if (toDo.equalsIgnoreCase("Edit")) {
            question = faqManager.getQuestionById(questionId);
            maxDisPos = faqManager.getFAQQuestions(question.getCategoryId()).size() + 1;
        } else {
            maxDisPos = faqManager.getFAQQuestions(categories.get(0).getId()).size();
            question.setDisplayPos(maxDisPos + 1);
            question.setCategoryId(categories.get(0).getId());
            maxDisPos = maxDisPos + 1;
        }
        
        mav.addObject("question", question);
        mav.addObject("categories", categories);
        
        //we add max display order
        mav.addObject("maxPos", maxDisPos);
        mav.setViewName("/faq/questionModal");
        return mav;
    }
    
    
    
    @RequestMapping(value = "/saveQuestion.do", method = RequestMethod.POST)
    public @ResponseBody
    ModelAndView saveQuestion(@ModelAttribute(value = "question") faqQuestions question, BindingResult errors) 
            throws Exception {
        
        Integer maxDisPos = faqManager.getFAQQuestions(question.getCategoryId()).size();
        
        ModelAndView mav = new ModelAndView();
        
        faqQuestions questionToReplace = faqManager.getQuestionByDspPos(question.getCategoryId(), question.getDisplayPos());
                    
        //see if any category is using the new display position
        if (questionToReplace != null) {
                if(question.getId() == 0) {
                    questionToReplace.setDisplayPos(maxDisPos);
                } else {
                    //get old position
                    questionToReplace.setDisplayPos(faqManager.getQuestionById(question.getId()).getDisplayPos());
                }
                faqManager.saveQuestion(questionToReplace);
        }
        //insert or update here
        faqManager.saveQuestion(question);
        //return correct message
        mav.setViewName("/faq/result");
        if (question.getId() == 0) {
            mav.addObject("edited", 1);
        } else {
            mav.addObject("edited", 2);
        }
        return mav;
    }
    
    
}
