/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.rr.missouri.ui.surveys;

import com.registryKit.client.clientManager;
import com.registryKit.client.engagementManager;
import com.registryKit.hierarchy.hierarchyManager;
import com.registryKit.hierarchy.programHierarchyDetails;
import com.registryKit.survey.SurveyPages;
import com.registryKit.survey.SurveyQuestionChoices;
import com.registryKit.survey.SurveyQuestions;
import com.registryKit.survey.submittedSurveys;
import com.registryKit.survey.survey;
import com.registryKit.survey.surveyManager;
import com.registryKit.survey.surveyQuestionAnswers;
import com.registryKit.survey.surveys;
import com.registryKit.user.User;
import com.registryKit.user.userManager;
import com.registryKit.user.userProgramModules;
import com.rr.missouri.ui.districts.district;
import com.rr.missouri.ui.districts.school;
import com.rr.missouri.ui.security.decryptObject;
import com.rr.missouri.ui.security.encryptObject;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.ListIterator;
import java.util.Map;
import java.util.concurrent.CopyOnWriteArrayList;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import org.springframework.web.servlet.view.RedirectView;

/**
 *
 * @author chadmccue
 */
@Controller
@RequestMapping("/surveys")
public class surveyController {

    private static Integer moduleId = 11;

    @Autowired
    private clientManager clientmanager;

    @Autowired
    private surveyManager surveyManager;

    @Autowired
    private engagementManager engagementmanager;

    @Autowired
    private hierarchyManager hierarchymanager;

    @Autowired
    private userManager usermanager;

    @Value("${programId}")
    private Integer programId;

    @Value("${topSecret}")
    private String topSecret;

    /* Variable to hold answers while taking a survey */
    private static List<surveyQuestionAnswers> questionAnswers = null;

    /* Keep track of visited pages */
    private static List<Integer> seenPages;

    private static List<surveys> surveys;

    private static boolean allowCreate = false;
    private static boolean allowEdit = false;

    /**
     * The '' request will display the list of taken surveys.
     *
     * @param request
     * @param response
     * @return	the administrator dashboard view
     * @throws Exception
     */
    @RequestMapping(value = "", method = RequestMethod.GET)
    public ModelAndView listSubmittedSurveys(@RequestParam(value = "i", required = false) String i, @RequestParam(value = "v", required = false) String v, HttpSession session) throws Exception {

        ModelAndView mav = new ModelAndView();
        mav.setViewName("/surveys");

        /* Get a list of surveys  */
        List<surveys> surveyList = surveyManager.getProgramSurveys(programId);

        encryptObject encrypt = new encryptObject();
        Map<String, String> map;

        for (surveys survey : surveyList) {
            //Encrypt the use id to pass in the url
            map = new HashMap<String, String>();
            map.put("id", Integer.toString(survey.getId()));
            map.put("topSecret", topSecret);

            String[] encrypted = encrypt.encryptObject(map);

            survey.setEncryptedId(encrypted[0]);
            survey.setEncryptedSecret(encrypted[1]);

        }
        surveys = surveyList;
        mav.addObject("surveys", surveyList);

        Integer surveyId;

        /* Get the submitted surveys for the selected survey type */
        if (!"".equals(i) && i != null && !"".equals(v) && v != null) {
            /* Decrypt the url */
            decryptObject decrypt = new decryptObject();

            Object obj = decrypt.decryptObject(i, v);

            String[] result = obj.toString().split((","));

            surveyId = Integer.parseInt(result[0].substring(4));

        } else {
            surveyId = surveyList.get(0).getId();
        }
        mav.addObject("selSurvey", surveyId);

        surveys surveyDetails = surveyManager.getSurveyDetails(surveyId);
        mav.addObject("surveyName", surveyDetails.getTitle());

        /* Get a list of completed surveys the logged in user has access to */
        User userDetails = (User) session.getAttribute("userDetails");

        List<submittedSurveys> submittedSurveys = surveyManager.getEntitySurveys(userDetails.getId());

        /* Need to get the selected entities */
        if (submittedSurveys != null && !submittedSurveys.isEmpty()) {

            for (submittedSurveys survey : submittedSurveys) {

                //Encrypt the use id to pass in the url
                map = new HashMap<String, String>();
                map.put("id", Integer.toString(survey.getId()));
                map.put("topSecret", topSecret);

                String[] encrypted = encrypt.encryptObject(map);

                survey.setEncryptedId(encrypted[0]);
                survey.setEncryptedSecret(encrypted[1]);

                List<Integer> selectedEntities = surveyManager.getSubmittedSurveyEntities(survey.getId(), userDetails.getId());

                if (selectedEntities != null && !selectedEntities.isEmpty()) {

                    List<String> entityList = new ArrayList<String>();

                    for (Integer entityId : selectedEntities) {
                        programHierarchyDetails entityDetails = hierarchymanager.getProgramHierarchyItemDetails(entityId);

                        entityList.add(entityDetails.getName());
                    }

                    survey.setSelectedEntities(entityList);

                }

            }

        }

        mav.addObject("submittedSurveys", submittedSurveys);

        /* Get user permissions */
        userProgramModules modulePermissions = usermanager.getUserModulePermissions(programId, userDetails.getId(), moduleId);
        allowCreate = modulePermissions.isAllowCreate();
        allowEdit = modulePermissions.isAllowEdit();

        mav.addObject("allowCreate", allowCreate);
        mav.addObject("allowEdit", allowEdit);

        return mav;
    }

    /**
     * The '/startSurvey' GET request will build out the survey and display the first page of the survey.
     *
     * @param i The encrypted client id
     * @param v The encrypted decryption key
     * @param s The id of the selected survey
     *
     * @param session
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/startSurvey", method = RequestMethod.POST)
    public ModelAndView startSurvey(@RequestParam String s, @RequestParam(value = "selectedEntities", required = false) List<Integer> selectedEntities, HttpSession session) throws Exception {

        ModelAndView mav = new ModelAndView();
        mav.setViewName("/takeSurvey");
        mav.addObject("surveys", surveys);

        //Set the survey answer array to get ready to hold data
        questionAnswers = new CopyOnWriteArrayList<surveyQuestionAnswers>();
        seenPages = new ArrayList<Integer>();

        int clientId = 0;

        Integer surveyId = Integer.parseInt(s);

        if (surveyId > 0) {

            surveys surveyDetails = surveyManager.getSurveyDetails(surveyId);

            /* Make sure the survey is part of this program and active */
            if (surveyDetails.getProgramId() != programId || surveyDetails.getStatus() == false) {

                /* Redirect back to the survey list page */
            } /* Set up the survey */ else {
                survey survey = new survey();
                survey.setClientId(clientId);
                survey.setSurveyId(surveyId);
                survey.setSurveyTitle(surveyDetails.getTitle());
                survey.setPrevButton(surveyDetails.getPrevButtonText());
                survey.setNextButton(surveyDetails.getNextButtonText());
                survey.setSaveButton(surveyDetails.getDoneButtonText());
                survey.setSubmittedSurveyId(0);

                encryptObject encrypt = new encryptObject();
                Map<String, String> map;

                map = new HashMap<String, String>();
                map.put("id", Integer.toString(surveyId));
                map.put("topSecret", topSecret);

                String[] encrypted = encrypt.encryptObject(map);

                survey.setEncryptedId(encrypted[0]);
                survey.setEncryptedSecret(encrypted[1]);

                /* Get the pages */
                List<SurveyPages> surveyPages = surveyManager.getSurveyPages(surveyId, false, 0, 0, 0);
                SurveyPages currentPage = surveyManager.getSurveyPage(surveyId, true, 1, clientId, 0, 0, 0);
                survey.setPageTitle(currentPage.getPageTitle());
                survey.setSurveyPageQuestions(currentPage.getSurveyQuestions());
                survey.setTotalPages(surveyPages.size());

                mav.addObject("survey", survey);
                mav.addObject("surveyPages", surveyPages);
            }
        } else {
            /* Redirect back to the survey list page */

        }

        User userDetails = (User) session.getAttribute("userDetails");

        /* Get a list of available schools for the selected districts */
        if (selectedEntities != null && !selectedEntities.isEmpty() && !"".equals(selectedEntities)) {

            encryptObject encrypt = new encryptObject();
            Map<String, String> map;

            List<school> schoolList = new ArrayList<school>();
            List<district> districtList = new ArrayList<district>();

            for (Integer entity : selectedEntities) {

                district district = new district();
                district.setDistrictId(entity);

                programHierarchyDetails districtDetails = hierarchymanager.getProgramHierarchyItemDetails(entity);
                district.setDistrictName(districtDetails.getName());

                List schools = hierarchymanager.getProgramOrgHierarchyItems(programId, 3, entity, userDetails.getId());

                if (!schools.isEmpty() && schools.size() > 0) {

                    for (ListIterator iter = schools.listIterator(); iter.hasNext();) {

                        Object[] row = (Object[]) iter.next();

                        school school = new school();
                        school.setSchoolId(Integer.parseInt(row[0].toString()));
                        school.setSchoolName(row[1].toString());

                        //Encrypt the use id to pass in the url
                        map = new HashMap<String, String>();
                        map.put("id", Integer.toString(Integer.parseInt(row[0].toString())));
                        map.put("topSecret", topSecret);

                        String[] encrypted = encrypt.encryptObject(map);

                        school.setEncryptedId(encrypted[0]);
                        school.setEncryptedSecret(encrypted[1]);

                        schoolList.add(school);

                    }

                    district.setSchoolList(schoolList);

                }

                districtList.add(district);

            }

            mav.addObject("selDistricts", districtList);

        }

        mav.addObject("selSurvey", surveyId);

        mav.addObject("selectedEntities", selectedEntities.toString().replace("[", "").replace("]", ""));
        mav.addObject("currentPage", 1);

        mav.addObject("qNum", 0);

        return mav;
    }

    /**
     * The '/editSurvey' GET request will build out the survey and display the first page of the survey.
     *
     * @param i The encrypted survey id
     * @param v The encrypted decryption key
     *
     * @param session
     * @return
     * @throws Exception
     */
    @RequestMapping(value = {"/editSurvey","/viewSurvey"}, method = RequestMethod.GET)
    public ModelAndView editSurvey(@RequestParam String i, @RequestParam String v, HttpSession session, HttpServletRequest request) throws Exception {

        ModelAndView mav = new ModelAndView();
        mav.setViewName("/takeSurvey");
        mav.addObject("surveys", surveys);

        //Set the survey answer array to get ready to hold data
        questionAnswers = new CopyOnWriteArrayList<surveyQuestionAnswers>();
        seenPages = new ArrayList<Integer>();

        int clientId = 0;

        /* Decrypt the url */
        decryptObject decrypt = new decryptObject();

        Object obj = decrypt.decryptObject(i, v);

        String[] result = obj.toString().split((","));

        int submittedSurveyId = Integer.parseInt(result[0].substring(4));

        /* Get the survey details */
        submittedSurveys submittedSurveyDetails = surveyManager.getSubmittedSurvey(submittedSurveyId);

        surveys surveyDetails = surveyManager.getSurveyDetails(submittedSurveyDetails.getSurveyId());

        User userDetails = (User) session.getAttribute("userDetails");

        survey survey = new survey();
        survey.setClientId(clientId);
        survey.setSurveyId(submittedSurveyDetails.getSurveyId());
        survey.setSurveyTitle(surveyDetails.getTitle());
        survey.setPrevButton(surveyDetails.getPrevButtonText());
        survey.setNextButton(surveyDetails.getNextButtonText());
        survey.setSaveButton(surveyDetails.getDoneButtonText());
        survey.setSubmittedSurveyId(submittedSurveyId);
        survey.setEntityIds(surveyManager.getSubmittedSurveyEntities(submittedSurveyId, userDetails.getId()));

        encryptObject encrypt = new encryptObject();
        Map<String, String> map;

        //Encrypt the use id to pass in the url
        map = new HashMap<String, String>();
        map.put("id", Integer.toString(submittedSurveyDetails.getSurveyId()));
        map.put("topSecret", topSecret);

        String[] encrypted = encrypt.encryptObject(map);

        survey.setEncryptedId(encrypted[0]);
        survey.setEncryptedSecret(encrypted[1]);

        /* Get the pages */
        List<SurveyPages> surveyPages = surveyManager.getSurveyPages(submittedSurveyDetails.getSurveyId(), false, 0, 0, 0);
        SurveyPages currentPage = surveyManager.getSurveyPage(submittedSurveyDetails.getSurveyId(), true, 1, clientId, 0, 0, submittedSurveyId);
        survey.setPageTitle(currentPage.getPageTitle());
        survey.setSurveyPageQuestions(currentPage.getSurveyQuestions());
        survey.setTotalPages(surveyPages.size());

        mav.addObject("survey", survey);
        mav.addObject("surveyPages", surveyPages);

        List<Integer> selectedEntities = surveyManager.getSurveyEntities(submittedSurveyId);

        /* Get a list of available schools for the selected districts */
        if (selectedEntities != null && !selectedEntities.isEmpty() && !"".equals(selectedEntities)) {

            List<school> schoolList = new ArrayList<school>();
            List<district> districtList = new ArrayList<district>();

            for (Integer entityId : selectedEntities) {

                district district = new district();
                district.setDistrictId(entityId);

                programHierarchyDetails districtDetails = hierarchymanager.getProgramHierarchyItemDetails(entityId);
                district.setDistrictName(districtDetails.getName());

                List schools = hierarchymanager.getProgramOrgHierarchyItems(programId, 3, entityId, userDetails.getId());

                if (!schools.isEmpty() && schools.size() > 0) {

                    for (ListIterator iter = schools.listIterator(); iter.hasNext();) {

                        Object[] row = (Object[]) iter.next();

                        school school = new school();
                        school.setSchoolId(Integer.parseInt(row[0].toString()));
                        school.setSchoolName(row[1].toString());

                        //Encrypt the use id to pass in the url
                        map = new HashMap<String, String>();
                        map.put("id", Integer.toString(Integer.parseInt(row[0].toString())));
                        map.put("topSecret", topSecret);

                        String[] encrypted2 = encrypt.encryptObject(map);

                        school.setEncryptedId(encrypted2[0]);
                        school.setEncryptedSecret(encrypted2[1]);

                        schoolList.add(school);

                    }

                    district.setSchoolList(schoolList);

                }

                districtList.add(district);

            }

            mav.addObject("selDistricts", districtList);

        }

        mav.addObject("selSurvey", submittedSurveyDetails.getSurveyId());
        mav.addObject("selectedEntities", selectedEntities.toString().replace("[", "").replace("]", ""));

        mav.addObject("qNum", 0);
        
        boolean disabled = false;
        if("/surveys/viewSurvey".equals(request.getServletPath())) {
            disabled = true;
        }
        mav.addObject("disabled", disabled);

        return mav;
    }

    /**
     * The '/takeSurvey' POST request will submit the survey page.
     *
     * @param client The object containing all the client detail form fields
     * @param i The encrypted url value containing the selected user id
     * @param v The encrypted url value containing the secret decode key
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/submitSurvey", method = RequestMethod.POST)
    public ModelAndView saveSurveyPage(@ModelAttribute(value = "survey") survey survey, HttpSession session,
            RedirectAttributes redirectAttr, @RequestParam String action, @RequestParam Integer goToPage, @RequestParam(value = "entityIds", required = false) List<String> entityIds,
            @RequestParam(value = "selectedDistricts", required = false) List<String> selectedEntities,
            @RequestParam(value = "disabled", required = true) boolean disabled) throws Exception {

        Integer goToQuestion = 0;
        boolean skipToEnd = false;
        boolean submitted = false;

        if (!"".equals(entityIds) && !entityIds.isEmpty()) {
            List<Integer> entityIdList = new ArrayList<Integer>();

            for (String entityId : entityIds) {
                Integer entityIdasInt = Integer.parseInt(entityId);

                entityIdList.add(entityIdasInt);
            }
            survey.setEntityIds(entityIdList);
        }

        if ("next".equals(action) || "done".equals(action) || "save".equals(action)) {
            goToPage = 0;
            Integer lastQuestionSaved = 0;
            List<SurveyQuestions> questions = survey.getSurveyPageQuestions();

            for (SurveyQuestions question : questions) {

                boolean questionFound = false;

                Iterator<surveyQuestionAnswers> it = questionAnswers.iterator();

                while (it.hasNext()) {
                    surveyQuestionAnswers questionAnswer = it.next();

                    if (questionAnswer.getQuestionId() == question.getId()) {

                        questionFound = true;

                        if (question.getAnswerTypeId() == 1) {
                            SurveyQuestionChoices choiceDetails = surveyManager.getSurveyQuestionChoice(Integer.parseInt(question.getQuestionValue()));

                            if (choiceDetails.getChoiceValue() > 0) {
                                questionAnswer.setAnswerId(choiceDetails.getChoiceValue());
                            } else {
                                questionAnswer.setAnswerText(choiceDetails.getChoiceText());
                            }

                            if (choiceDetails.isSkipToEnd() == true) {
                                skipToEnd = true;
                            } else {
                                if (choiceDetails.getSkipToPageId() > 0) {
                                    SurveyPages pageDetails = surveyManager.getSurveyPageDetails(choiceDetails.getSkipToPageId());
                                    goToPage = pageDetails.getPageNum();
                                }

                                goToQuestion = choiceDetails.getSkipToQuestionId();
                            }

                            questionAnswer.setAnswerOther(question.getQuestionOtherValue());

                        } else {
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

                if (questionFound == false) {
                    surveyQuestionAnswers questionAnswer = new surveyQuestionAnswers();

                    if (question.getAnswerTypeId() == 1 && !"".equals(question.getQuestionValue())) {

                        SurveyQuestionChoices choiceDetails = surveyManager.getSurveyQuestionChoice(Integer.parseInt(question.getQuestionValue()));

                        if (choiceDetails.getChoiceValue() > 0) {
                            questionAnswer.setAnswerId(choiceDetails.getChoiceValue());
                        } else {
                            questionAnswer.setAnswerText(choiceDetails.getChoiceText());
                        }

                        if (choiceDetails.isSkipToEnd() == true) {
                            skipToEnd = true;
                        } else {
                            if (choiceDetails.getSkipToPageId() > 0) {
                                SurveyPages pageDetails = surveyManager.getSurveyPageDetails(choiceDetails.getSkipToPageId());
                                goToPage = pageDetails.getPageNum();
                            }

                            goToQuestion = choiceDetails.getSkipToQuestionId();
                        }

                        questionAnswer.setAnswerOther(question.getQuestionOtherValue());

                    } else {
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

                if (questionAnswer.getqNum() > lastQuestionSaved) {
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
        NextPage.setSubmittedSurveyId(survey.getSubmittedSurveyId());

        SurveyPages currentPage = null;
        Integer qNum = 1;
        Integer nextPage = 1;

        /* Get the pages */
        List<SurveyPages> surveyPages = surveyManager.getSurveyPages(survey.getSurveyId(), false, 0, 0, 0);

        if ("prev".equals(action)) {
            mav.setViewName("/takeSurvey");

            nextPage = seenPages.get(seenPages.size() - 1);
            /* Remove this page from array */
            seenPages.remove(seenPages.size() - 1);

            currentPage = surveyManager.getSurveyPage(survey.getSurveyId(), true, nextPage, survey.getClientId(), 0, goToQuestion, survey.getSubmittedSurveyId());

            Integer totalPageQuestions = 0;
            for (SurveyQuestions question : currentPage.getSurveyQuestions()) {
                if (question.getAnswerTypeId() != 7) {
                    totalPageQuestions += 1;
                }
            }

            qNum = (survey.getLastQNumAnswered() - totalPageQuestions) - 1;
        } else if ("next".equals(action)) {
            mav.setViewName("/takeSurvey");

            if (goToPage > 0) {
                nextPage = goToPage;
            } else {
                nextPage = survey.getCurrentPage() + 1;
            }

            seenPages.add(survey.getCurrentPage());

            currentPage = surveyManager.getSurveyPage(survey.getSurveyId(), true, nextPage, survey.getClientId(), 0, goToQuestion, survey.getSubmittedSurveyId());

            qNum = survey.getLastQNumAnswered();

        } else if ("save".equals(action)) {
            submitted = false;
        } else if ("done".equals(action)) {
            skipToEnd = true;
            submitted = true;
        }

        /**
         * If saving the survey, save and redirect to the survey list page *
         */
        if ("save".equals(action)) {
            User userDetails = (User) session.getAttribute("userDetails");

            /**
             * Submit answers to DB *
             */
            surveyManager.submitSurvey(userDetails.getId(), programId, survey, questionAnswers, submitted, selectedEntities);

            encryptObject encrypt = new encryptObject();
            Map<String, String> map;

            //Encrypt the use id to pass in the url
            map = new HashMap<String, String>();
            map.put("id", Integer.toString(survey.getSurveyId()));
            map.put("topSecret", topSecret);

            String[] encrypted = encrypt.encryptObject(map);

            mav = new ModelAndView(new RedirectView("/surveys?i=" + encrypted[0] + "&v=" + encrypted[1]));
        } /**
         * If reached the last page or an option was selected to skip to the end *
         */
        else if (currentPage == null || skipToEnd == true) {
            
            if(disabled == false) {
                User userDetails = (User) session.getAttribute("userDetails");

                /**
                 * Submit answers to DB *
                 */
                surveyManager.submitSurvey(userDetails.getId(), programId, survey, questionAnswers, submitted, selectedEntities);

                mav.setViewName("/completedSurvey");
                surveys surveyDetails = surveyManager.getSurveyDetails(survey.getSurveyId());
                mav.addObject("surveyDetails", surveyDetails);
            }
            else {
                
            }
            
        } else {
            NextPage.setPageTitle(currentPage.getPageTitle());
            NextPage.setSurveyPageQuestions(currentPage.getSurveyQuestions());

            /* Loop through to get actually question answers */
            for (SurveyQuestions question : currentPage.getSurveyQuestions()) {

                Iterator<surveyQuestionAnswers> it = questionAnswers.iterator();

                while (it.hasNext()) {
                    surveyQuestionAnswers questionAnswer = it.next();

                    if (questionAnswer.getQuestionId() == question.getId()) {

                        if (questionAnswer.getAnswerId() > 0) {
                            question.setQuestionValue(String.valueOf(questionAnswer.getAnswerId()));
                        } else {
                            question.setQuestionValue(questionAnswer.getAnswerText());
                        }
                    }
                }
            }

            NextPage.setTotalPages(surveyPages.size());
            NextPage.setCurrentPage(nextPage);

            mav.addObject("survey", NextPage);
            mav.addObject("surveyPages", surveyPages);
            mav.addObject("qNum", qNum);
            mav.addObject("selectedEntities", selectedEntities);
        }

        return mav;
    }

}
