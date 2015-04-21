/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.rr.missouri.ui.surveys;

import com.registryKit.client.clientManager;
import com.registryKit.client.engagementManager;
import com.registryKit.client.engagements;
import com.registryKit.client.storageClientAddressInfo;
import com.registryKit.client.storageClients;
import com.registryKit.survey.SurveyPages;
import com.registryKit.survey.SurveyQuestionChoices;
import com.registryKit.survey.SurveyQuestions;
import com.registryKit.survey.patientCompletedSurveys;
import com.registryKit.survey.survey;
import com.registryKit.survey.surveyManager;
import com.registryKit.survey.surveyQuestionAnswers;
import com.registryKit.survey.surveys;
import com.registryKit.user.User;
import com.rr.missouri.ui.clients.clientSummary;
import com.rr.missouri.ui.security.decryptObject;
import java.net.URLEncoder;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;
import java.util.concurrent.CopyOnWriteArrayList;
import javax.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

/**
 *
 * @author chadmccue
 */
@Controller
@RequestMapping("/clients/surveys")
public class surveyController {
    
   @Autowired
   private clientManager clientmanager;
   
   @Autowired
   private surveyManager surveyManager;
   
   @Autowired
   private engagementManager engagementmanager;
    
   @Value("${programId}")
   private Integer programId;
   
   @Value("${topSecret}")
   private String topSecret;
   
   /* Variable to hold answers while taking a survey */
   private static List<surveyQuestionAnswers> questionAnswers = null;
   
   /* Keep track of visited pages */
   private static List<Integer> seenPages;
   
   /**
     * The '' request will display the list of taken surveys.
     *
     * @param request
     * @param response
     * @return	the administrator dashboard view
     * @throws Exception
     */
    @RequestMapping(value = "", method = RequestMethod.GET)
    public ModelAndView listSurveys(@RequestParam String i, @RequestParam String v, HttpSession session) throws Exception {
        
        ModelAndView mav = new ModelAndView();
        mav.setViewName("/surveys");
        
        mav.addObject("iparam", URLEncoder.encode(i,"UTF-8"));
        mav.addObject("vparam", URLEncoder.encode(v,"UTF-8"));
        
        /* Decrypt the url */
        decryptObject decrypt = new decryptObject();
        
        Object obj = decrypt.decryptObject(i, v);
        
        String[] result = obj.toString().split((","));
        
        int clientId = Integer.parseInt(result[0].substring(4));
        
        clientSummary summary = new clientSummary();
        
        storageClients clientDetails = clientmanager.getClientDetails(clientId);
        storageClientAddressInfo addressInfo = clientmanager.getClientAddressInfo(clientId);
        
        summary.setName(clientDetails.getFirstName()+" "+clientDetails.getLastName());
        summary.setSourcePatientId(clientDetails.getSourcePatientId());
        summary.setDateReferred(clientDetails.getDateCreated());
        summary.setAddress(addressInfo.getAddress1());
        summary.setAddress2(addressInfo.getAddress2());
        summary.setCity(addressInfo.getCity());
        summary.setState(addressInfo.getState());
        summary.setZip(addressInfo.getZipCode());
        summary.setPhoneNumber(addressInfo.getPhone1());
        summary.setDob(clientDetails.getDob());
        
        mav.addObject("summary", summary);
        
        /* Get a list of completed surveys not associated to enagements */
        List<patientCompletedSurveys> completedSurveys = surveyManager.getPatientSurveysNoEngagement(clientId, programId);
        mav.addObject("completedSurveys", completedSurveys);
        
        /* Get a list of completed surveys associated to engagements */
        List<engagements> engagementSurveys = new ArrayList<engagements>();
        
        List<engagements> engagements = engagementmanager.getEngagements(clientId, programId);
        
        if(engagements != null && engagements.size() > 0) {
            for(engagements engagement : engagements) {
                
                List<patientCompletedSurveys> surveys = surveyManager.getPatientEngagementSurveys(clientId, engagement.getId());
                
                if(surveys != null && surveys.size() > 0) {
                    engagement.setEngagementSurveys(surveys);
                    engagementSurveys.add(engagement);
                }
            }
            mav.addObject("engagementSurveys", engagementSurveys);
        }
        
        return mav;
    }
    
    /**
     * The 'getAvailableSurveys.do' GET request will return the list of available surveys for the program.
     * 
      * @param session
     * @return
     * @throws Exception 
     */
    @RequestMapping(value = "getAvailableSurveys.do", method = RequestMethod.GET)
    public @ResponseBody ModelAndView getAvailableSurveys(HttpSession session) throws Exception {
        
        ModelAndView mav = new ModelAndView();
        mav.setViewName("/clients/survey/startASurvey");
        
        /* Get a list of available surveys */
        List<surveys> availableSurveys = surveyManager.getProgramSurveys(programId);
       
        mav.addObject("availableSurveys", availableSurveys);
        
        return mav;
    }
    
    /**
     * The '/takeSurvey' GET request will build out the survey and display the first page of the survey.
     * 
     * @param i The encrypted client id
     * @param v The encrypted decryption key
     * @param s The id of the selected survey
     * 
     * @param session
     * @return
     * @throws Exception 
     */
    @RequestMapping(value = "/takeSurvey", method = RequestMethod.GET) 
    public ModelAndView startSurvey(@RequestParam String i, @RequestParam String v, @RequestParam Integer c, @RequestParam String s, HttpSession session) throws Exception {
        
        ModelAndView mav = new ModelAndView();
        mav.setViewName("/takeSurvey");
        
        //Set the survey answer array to get ready to hold data
        questionAnswers = new CopyOnWriteArrayList<surveyQuestionAnswers>();
        seenPages = new ArrayList<Integer>();
        
        /* Decrypt the url */
        decryptObject decrypt = new decryptObject();
        
        Object obj = decrypt.decryptObject(i, v);
        
        String[] result = obj.toString().split((","));
        
        int clientId = Integer.parseInt(result[0].substring(4));
    
        clientSummary summary = new clientSummary();
        
        storageClients clientDetails = clientmanager.getClientDetails(clientId);
        storageClientAddressInfo addressInfo = clientmanager.getClientAddressInfo(clientId);
        
        summary.setName(clientDetails.getFirstName()+" "+clientDetails.getLastName());
        summary.setSourcePatientId(clientDetails.getSourcePatientId());
        summary.setDateReferred(clientDetails.getDateCreated());
        summary.setAddress(addressInfo.getAddress1());
        summary.setAddress2(addressInfo.getAddress2());
        summary.setCity(addressInfo.getCity());
        summary.setState(addressInfo.getState());
        summary.setZip(addressInfo.getZipCode());
        summary.setPhoneNumber(addressInfo.getPhone1());
        summary.setDob(clientDetails.getDob());
        
        mav.addObject("summary", summary);
        
        Integer surveyId = Integer.parseInt(s);
        
        if(surveyId > 0) {
            
            surveys surveyDetails = surveyManager.getSurveyDetails(surveyId);
            
            /* Make sure the survey is part of this program and active */
            if(surveyDetails.getProgramId() != programId || surveyDetails.getStatus() == false) {
                
                /* Redirect back to the survey list page */
                
            }
            /* Set up the survey */
            else {
                survey survey = new survey();
                survey.setClientId(clientId);
                survey.setSurveyId(surveyId);
                survey.setSurveyTitle(surveyDetails.getTitle());
                survey.setPrevButton(surveyDetails.getPrevButtonText());
                survey.setNextButton(surveyDetails.getNextButtonText());
                survey.setSaveButton(surveyDetails.getDoneButtonText());
                survey.setCompletedSurveyId(c);
                
                /* Get the pages */
                List<SurveyPages> surveyPages = surveyManager.getSurveyPages(surveyId, false, 0, 0, 0);
                SurveyPages currentPage = surveyManager.getSurveyPage(surveyId, true, 1, clientId, 0, 0, c);
                survey.setPageTitle(currentPage.getPageTitle());
                survey.setSurveyPageQuestions(currentPage.getSurveyQuestions());
                survey.setTotalPages(surveyPages.size());
                
                mav.addObject("survey", survey);
                mav.addObject("surveyPages", surveyPages);
            }
        }
        else {
            /* Redirect back to the survey list page */
            
        }
        
        mav.addObject("iparam", URLEncoder.encode(i,"UTF-8"));
        mav.addObject("vparam", URLEncoder.encode(v,"UTF-8"));
        mav.addObject("qNum", 0);
        
        return mav;
    }
    
    /**
     * The '/takeSurvey' POST request will submit the survey page.
     * 
     * @param client    The object containing all the client detail form fields
     * @param i     The encrypted url value containing the selected user id
     * @param v     The encrypted url value containing the secret decode key
     * @return
     * @throws Exception 
     */
    @RequestMapping(value = "/takeSurvey", method = RequestMethod.POST)
    public ModelAndView saveSurveyPage(@ModelAttribute(value = "survey") survey survey, HttpSession session, 
            RedirectAttributes redirectAttr, @RequestParam String action, @RequestParam String i, @RequestParam String v, @RequestParam Integer goToPage) throws Exception {
        
        /* Decrypt the url */
        decryptObject decrypt = new decryptObject();

        Object obj = decrypt.decryptObject(i, v);

        String[] result = obj.toString().split((","));

        int clientId = Integer.parseInt(result[0].substring(4));

        clientSummary summary = new clientSummary();

        storageClients clientDetails = clientmanager.getClientDetails(clientId);
        storageClientAddressInfo addressInfo = clientmanager.getClientAddressInfo(clientId);

        summary.setName(clientDetails.getFirstName()+" "+clientDetails.getLastName());
        summary.setSourcePatientId(clientDetails.getSourcePatientId());
        summary.setDateReferred(clientDetails.getDateCreated());
        summary.setAddress(addressInfo.getAddress1());
        summary.setAddress2(addressInfo.getAddress2());
        summary.setCity(addressInfo.getCity());
        summary.setState(addressInfo.getState());
        summary.setZip(addressInfo.getZipCode());
        summary.setPhoneNumber(addressInfo.getPhone1());
        summary.setDob(clientDetails.getDob());
        
        Integer goToQuestion = 0;
        boolean skipToEnd = false;
        
        if ("next".equals(action) || "done".equals(action)) {
            goToPage = 0;
            Integer lastQuestionSaved = 0;
            List<SurveyQuestions> questions = survey.getSurveyPageQuestions();

            for(SurveyQuestions question : questions) {

                boolean questionFound = false;

                Iterator<surveyQuestionAnswers> it = questionAnswers.iterator();
                
                while (it.hasNext()) {
                    surveyQuestionAnswers questionAnswer = it.next();

                    if(questionAnswer.getQuestionId() == question.getId()) {

                        questionFound = true;
                        
                        if(question.getAnswerTypeId() == 1) {
                            SurveyQuestionChoices choiceDetails = surveyManager.getSurveyQuestionChoice(Integer.parseInt(question.getQuestionValue()));
                            
                            if(choiceDetails.getChoiceValue() > 0) {
                                questionAnswer.setAnswerId(choiceDetails.getChoiceValue());
                            }
                            else {
                                questionAnswer.setAnswerText(choiceDetails.getChoiceText());
                            }
                            
                            if(choiceDetails.isSkipToEnd() == true) {
                                skipToEnd = true;
                            }
                            else {
                                if(choiceDetails.getSkipToPageId() > 0) {
                                    SurveyPages pageDetails = surveyManager.getSurveyPageDetails(choiceDetails.getSkipToPageId());
                                    goToPage = pageDetails.getPageNum();
                                }

                                goToQuestion = choiceDetails.getSkipToQuestionId();
                            }
                            
                        }
                        else {
                           questionAnswer.setAnswerText(question.getQuestionValue()); 
                        }

                        questionAnswer.setQuestionId(question.getId());
                        questionAnswer.setProgramPatientId(survey.getClientId());
                        questionAnswer.setProgramEngagementId(survey.getEngagementId());
                        questionAnswer.setqNum(question.getQuestionNum());
                        questionAnswer.setSurveyPageId(question.getSurveyPageId());
                        questionAnswer.setSaveToFieldId(question.getSaveToFieldId());
                    }
                }

                if(questionFound == false) {
                    surveyQuestionAnswers questionAnswer = new surveyQuestionAnswers();
                    
                    if(question.getAnswerTypeId() == 1) {
                        
                        SurveyQuestionChoices choiceDetails = surveyManager.getSurveyQuestionChoice(Integer.parseInt(question.getQuestionValue()));

                        if(choiceDetails.getChoiceValue() > 0) {
                            questionAnswer.setAnswerId(choiceDetails.getChoiceValue());
                        }
                        else {
                            questionAnswer.setAnswerText(choiceDetails.getChoiceText());
                        }
                        
                        if(choiceDetails.isSkipToEnd() == true) {
                            skipToEnd = true;
                        }
                        else {
                            if(choiceDetails.getSkipToPageId() > 0) {
                                SurveyPages pageDetails = surveyManager.getSurveyPageDetails(choiceDetails.getSkipToPageId());
                                goToPage = pageDetails.getPageNum();
                            }

                            goToQuestion = choiceDetails.getSkipToQuestionId();
                        }
                        
                    }
                    else {
                       questionAnswer.setAnswerText(question.getQuestionValue()); 
                    }
                    
                    questionAnswer.setQuestionId(question.getId());
                    questionAnswer.setProgramPatientId(survey.getClientId());
                    questionAnswer.setProgramEngagementId(survey.getEngagementId());
                    questionAnswer.setqNum(question.getQuestionNum());
                    questionAnswer.setSurveyPageId(question.getSurveyPageId());
                    questionAnswer.setSaveToFieldId(question.getSaveToFieldId());

                    questionAnswers.add(questionAnswer);
                }
                
                lastQuestionSaved = question.getQuestionNum();
            }
            
            /* Remove questions passed the last question answered */
            Iterator<surveyQuestionAnswers> it = questionAnswers.iterator();
                
            while (it.hasNext()) {
                surveyQuestionAnswers questionAnswer = it.next();
                
                if(questionAnswer.getqNum() > lastQuestionSaved) {
                    it.remove();
                }
            }
            
        }
        
        ModelAndView mav = new ModelAndView(); 
         
        survey NextPage = new survey();
        NextPage.setClientId(survey.getClientId());
        NextPage.setSurveyId(survey.getSurveyId());
        NextPage.setSurveyTitle(survey.getSurveyTitle());
        NextPage.setPrevButton(survey.getPrevButton());
        NextPage.setNextButton(survey.getNextButton());
        NextPage.setSaveButton(survey.getSaveButton());
        NextPage.setCompletedSurveyId(survey.getCompletedSurveyId());
        
        
        SurveyPages currentPage = null;
        Integer qNum = 1;
        Integer nextPage = 1;
        
        /* Get the pages */
        List<SurveyPages> surveyPages = surveyManager.getSurveyPages(survey.getSurveyId(), false, 0, 0, 0);
        
        if ("prev".equals(action)) {
            mav.setViewName("/takeSurvey");
           
            nextPage = seenPages.get(seenPages.size()-1);
            /* Remove this page from array */
            seenPages.remove(seenPages.size()-1);
                
            currentPage = surveyManager.getSurveyPage(survey.getSurveyId(), true, nextPage, survey.getClientId(), 0, goToQuestion, survey.getCompletedSurveyId());
            
            Integer totalPageQuestions = 0;
            for(SurveyQuestions question : currentPage.getSurveyQuestions()) {
                if(question.getAnswerTypeId() != 7) {
                    totalPageQuestions+=1;
                }
            }
            
            qNum = (survey.getLastQNumAnswered() - totalPageQuestions)-1;
        }
        else if ("next".equals(action)) {
            mav.setViewName("/takeSurvey");
            
            if(goToPage > 0) {
                nextPage = goToPage;
            }
            else {
                nextPage = survey.getCurrentPage() + 1;
            }
            
            seenPages.add(survey.getCurrentPage());
            
            currentPage = surveyManager.getSurveyPage(survey.getSurveyId(), true, nextPage, survey.getClientId(), 0, goToQuestion, survey.getCompletedSurveyId());

            qNum = survey.getLastQNumAnswered();
            
        } 
        else if ("done".equals(action)) {
            skipToEnd = true;
        }
        
        /** If reached the last page or an option was selected to skip to the end **/
        if(currentPage == null || skipToEnd == true) {
            User userDetails = (User) session.getAttribute("userDetails");
            
            /** Submit answers to DB **/
            surveyManager.saveSurvey(userDetails.getId(), programId, survey, questionAnswers);
            
            mav.setViewName("/completedSurvey");
            surveys surveyDetails = surveyManager.getSurveyDetails(survey.getSurveyId());
            mav.addObject("surveyDetails", surveyDetails);
        }
        else {
            NextPage.setPageTitle(currentPage.getPageTitle());
            NextPage.setSurveyPageQuestions(currentPage.getSurveyQuestions());

            /* Loop through to get actually question answers */
            for(SurveyQuestions question : currentPage.getSurveyQuestions()) {

                Iterator<surveyQuestionAnswers> it = questionAnswers.iterator();

                while (it.hasNext()) {
                    surveyQuestionAnswers questionAnswer = it.next();

                    if(questionAnswer.getQuestionId()== question.getId()) {

                       if(questionAnswer.getAnswerId() > 0) {
                           question.setQuestionValue(String.valueOf(questionAnswer.getAnswerId()));
                       } 
                       else {
                           question.setQuestionValue(questionAnswer.getAnswerText());
                       }
                    }
                }
            }

            NextPage.setTotalPages(surveyPages.size());
            NextPage.setCurrentPage(nextPage);

            mav.addObject("summary", summary);
            mav.addObject("survey", NextPage);
            mav.addObject("surveyPages", surveyPages);
            mav.addObject("qNum", qNum);
        }
        
        mav.addObject("iparam", URLEncoder.encode(i,"UTF-8"));
        mav.addObject("vparam", URLEncoder.encode(v,"UTF-8"));
        return mav;
    }
    
   
    
    /**
     *  The 'viewSurvey' GET request will return the survey questions and responses in a read only one page format.
     * 
     * @param i  The encrypted client Id
     * @param v  The encrypted decryption key   
     * @param s  The selected completed survey Id.
     * @param session
     * @return
     * @throws Exception 
     */
    @RequestMapping(value = "/viewSurvey", method = RequestMethod.GET)
    public ModelAndView viewSurvey(@RequestParam String i, @RequestParam String v, @RequestParam Integer s, HttpSession session) throws Exception {
        
        ModelAndView mav = new ModelAndView();
        mav.setViewName("/viewSurvey");
        
        mav.addObject("iparam", URLEncoder.encode(i,"UTF-8"));
        mav.addObject("vparam", URLEncoder.encode(v,"UTF-8"));
        
        /* Decrypt the url */
        decryptObject decrypt = new decryptObject();
        
        Object obj = decrypt.decryptObject(i, v);
        
        String[] result = obj.toString().split((","));
        
        int clientId = Integer.parseInt(result[0].substring(4));
        
        clientSummary summary = new clientSummary();
        
        storageClients clientDetails = clientmanager.getClientDetails(clientId);
        storageClientAddressInfo addressInfo = clientmanager.getClientAddressInfo(clientId);
        
        summary.setName(clientDetails.getFirstName()+" "+clientDetails.getLastName());
        summary.setSourcePatientId(clientDetails.getSourcePatientId());
        summary.setDateReferred(clientDetails.getDateCreated());
        summary.setAddress(addressInfo.getAddress1());
        summary.setAddress2(addressInfo.getAddress2());
        summary.setCity(addressInfo.getCity());
        summary.setState(addressInfo.getState());
        summary.setZip(addressInfo.getZipCode());
        summary.setPhoneNumber(addressInfo.getPhone1());
        summary.setDob(clientDetails.getDob());
        
        mav.addObject("summary", summary);
        
        /* Get the survey details */
        patientCompletedSurveys completedSurveyDetails = surveyManager.getCompletedSurvey(s);
        
        
        List<SurveyPages> surveyPages = surveyManager.getSurveyPages(completedSurveyDetails.getSurveyId(), true, 0, 0, completedSurveyDetails.getId());
        mav.addObject("surveyPages", surveyPages);
        
        return mav;
        
    }
}
