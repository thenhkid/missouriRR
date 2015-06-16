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
import com.registryKit.faq.faqQuestionDocuments;
import com.registryKit.faq.faqQuestions;
import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.ModelAttribute;
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
        mav.addObject("activeCat", categoryList.get(0).getId());
        
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
    public //@ResponseBody
    ModelAndView saveCategory(@ModelAttribute(value = "category") faqCategories category, BindingResult errors) 
            throws Exception {
        
        Integer maxDisPos = faqManager.getFAQCategories(programId).size() + 1;
        ModelAndView mav = new ModelAndView();
        
        faqCategories categoryToReplace = faqManager.getCategoryByDspPos(programId, category.getDisplayPos());
                    
        //see if any category is using the new display position
        if (categoryToReplace != null) {
            if (categoryToReplace.getId() != 0) {
                    if(category.getId() == 0) {
                        categoryToReplace.setDisplayPos(maxDisPos);
                    } else {
                        //get old position
                        faqCategories categoryOld = faqManager.getCategoryById(category.getId());
                        categoryToReplace.setDisplayPos(categoryOld.getDisplayPos());
                        System.out.println(categoryToReplace.getCategoryName());
                    }
                    faqManager.saveCategory(categoryToReplace);
            }
        }

        //insert or update here
        if (category.getId() == 0) {
            //if someone keep hitting refresh
            category.setDisplayPos(maxDisPos + 1);
        }
        faqManager.saveCategory(category);
        //return correct message
        mav.setViewName("/faq");
        List <faqCategories> categoryList = faqManager.getFAQForProgram(programId);
        mav.addObject("categoryList", categoryList);
        mav.addObject("activeCat", category.getId());
        
        // here we define which tab should be active
        
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
    public // @ResponseBody
    ModelAndView deleteCategory(@ModelAttribute(value = "category") faqCategories category, BindingResult errors)
            throws Exception {
        
        faqManager.deleteCategory(category);
        //reorder all displayPos
        faqManager.reOrderCategoryByDspPos(programId);
   
        ModelAndView mav = new ModelAndView();
        mav.setViewName("/faq");
        List <faqCategories> categoryList = faqManager.getFAQForProgram(programId);
        mav.addObject("categoryList", categoryList);
        mav.addObject("activeCat", categoryList.get(0).getId());
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
        mav.setViewName("/faq/questionModal");
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
        mav.addObject("displayPos", question.getDisplayPos());
        
        /** add documents if any **/
        if (toDo.equalsIgnoreCase("Edit")) {
            List <faqQuestionDocuments> documentList = faqManager.getFAQQuestionDocuments(question.getId());
            mav.addObject("documentList", documentList);
        }
        return mav;
    }
    
    @RequestMapping(value = "/chagneDisplayPosList.do", method = RequestMethod.POST)
    public @ResponseBody
    ModelAndView getDisplayPosList(
            @RequestParam(value = "categoryId", required = true) Integer categoryId
            ) 
            throws Exception {
        ModelAndView mav = new ModelAndView();
        mav.setViewName("/faq/qDisplayPos");
        List <faqQuestions> questionList = faqManager.getFAQQuestions(categoryId);
        mav.addObject("displayPos", (questionList.size()+1));
        mav.addObject("maxPos", (questionList.size()+1));
        
        return mav;
    }
    
    @RequestMapping(value = "/saveQuestion.do", method = RequestMethod.POST)
    public
    ModelAndView saveQuestion(@ModelAttribute(value = "question") faqQuestions question, BindingResult errors,
            @RequestParam(value = "faqDocuments", required = false) List<MultipartFile> faqDocuments
            ) 
            throws Exception {
        
        Integer maxDisPos = faqManager.getFAQQuestions(question.getCategoryId()).size();
        ModelAndView mav = new ModelAndView();
        Integer activeQId = question.getId();
        //see if we are replacing a question's positon
        faqQuestions questionToReplace = faqManager.getQuestionByDspPos(question.getCategoryId(), question.getDisplayPos());
        
        //see if any category is using the new display position
        if (questionToReplace != null) {
            if(question.getId() == 0) {
                        //new question get the same position, question.getDisplayPos, old questions get max position
                        questionToReplace.setDisplayPos(maxDisPos +1);
                        faqManager.saveQuestion(questionToReplace);
                        faqManager.saveQuestion(question);
                    } else {
                        /**
                         * existing
                         * It is more complicated if question is existing and being moved to another category and
                         * have its displayPos changed.
                         */
                        faqQuestions questionOld = faqManager.getQuestionById(question.getId());
                        //1 we check to see if category has changed
                        if (question.getCategoryId() == questionOld.getCategoryId()) {
                            //we are just swapping places
                            questionToReplace.setDisplayPos(questionOld.getDisplayPos());
                            faqManager.saveQuestion(questionToReplace);
                            faqManager.saveQuestion(question);
                            
                        }  else {
                            //if it is not in the same category
                            //moving to same category means adding new question
                            questionToReplace.setDisplayPos(maxDisPos+1);
                            faqManager.saveQuestion(questionToReplace);
                            faqManager.saveQuestion(question);
                            //we reorder old category
                            faqManager.reOrderQuestionByDspPos(questionOld.getCategoryId());                           
                        } 
                    }
            }  else { //simply adding a new question
                question.setDisplayPos(maxDisPos +1);
                activeQId = faqManager.saveQuestion(question);
            }

        /** documents**/
        if (faqDocuments.size() > 0) {
            question.setId(activeQId);
            faqManager.saveDocuments(question, faqDocuments);
        }
        
        
        //return correct message
        mav.setViewName("/faq");
        List <faqCategories> categoryList = faqManager.getFAQForProgram(programId);
        mav.addObject("categoryList", categoryList);
        // here we define which tab should be active
        mav.addObject("activeCat", question.getCategoryId());
        mav.addObject("activeQuestion", activeQId);
        
        
        return mav;
    }
    
    @RequestMapping(value = "/deleteQuestion.do", method = RequestMethod.POST)
    public // @ResponseBody
    ModelAndView deleteCategory(@ModelAttribute(value = "question") faqQuestions question, BindingResult errors)
            throws Exception {
        
        faqManager.deleteQuestion(question);
        //reorder all displayPos
        faqManager.reOrderQuestionByDspPos(question.getCategoryId());
   
        ModelAndView mav = new ModelAndView();
        mav.setViewName("/faq");
        List <faqCategories> categoryList = faqManager.getFAQForProgram(programId);
        mav.addObject("categoryList", categoryList);
        mav.addObject("activeCat", categoryList.get(0).getId());
        return mav;
    }
    
    
    @RequestMapping(value = "/chagneQuestionList.do", method = RequestMethod.POST)
    public @ResponseBody
    ModelAndView getQuestionsList(
            @RequestParam(value = "categoryId", required = true) Integer categoryId
            ) 
            throws Exception {
        ModelAndView mav = new ModelAndView();
        mav.setViewName("/faq/questionDropDown");
        List <faqQuestions> questionList = faqManager.getFAQQuestions(categoryId);
        mav.addObject("displayPos", (questionList.size()+1));
        mav.addObject("maxPos", (questionList.size()+1));
        
        return mav;
    }
    
    @RequestMapping(value = "/deleteDocument.do", method = RequestMethod.POST)
    public @ResponseBody
    ModelAndView getDisplayDivList(
            @RequestParam(value = "documentId", required = true) Integer documentId
            ) 
            throws Exception {
        
        faqQuestionDocuments documentDetail = faqManager.getDocumentById(documentId);
        ModelAndView mav = new ModelAndView();
        mav.setViewName("/faq/qDocumentInc");
        List <faqQuestionDocuments> documentList = faqManager.getFAQQuestionDocuments(documentDetail.getFaqQuestionId());
        mav.addObject("documentList", documentList);
        return mav;
    }
    
    
}
